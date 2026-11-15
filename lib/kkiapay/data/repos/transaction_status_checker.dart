import 'package:dio/dio.dart';

import '../remote/pos_apis.dart';

/// Final outcome of a KkiaPay transaction, as reported by the KkiaPay API.
enum KkiapayTransactionOutcome { success, failed, pending, unknown }

/// Asks the KkiaPay API (`POST /api/v1/transactions/status`, public key only)
/// for the real status of a transaction.
///
/// The widget redirects to the callback URL at the end of the payment flow,
/// whether the payment succeeded or not: the redirect alone must never be
/// treated as a successful payment.
class TransactionStatusChecker {
  TransactionStatusChecker({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Polls the status until it is final ([KkiapayTransactionOutcome.success] or
  /// [KkiapayTransactionOutcome.failed]) or [attempts] run out.
  Future<KkiapayTransactionOutcome> check({
    required String apiKey,
    required String transactionId,
    required bool sandbox,
    int attempts = 10,
    Duration interval = const Duration(seconds: 3),
  }) async {
    var outcome = KkiapayTransactionOutcome.unknown;
    for (var i = 0; i < attempts; i++) {
      outcome = await _checkOnce(apiKey, transactionId, sandbox);
      if (outcome == KkiapayTransactionOutcome.success ||
          outcome == KkiapayTransactionOutcome.failed) {
        return outcome;
      }
      if (i < attempts - 1) await Future.delayed(interval);
    }
    return outcome;
  }

  Future<KkiapayTransactionOutcome> _checkOnce(
      String apiKey, String transactionId, bool sandbox) async {
    try {
      final response = await _dio.post<dynamic>(
        '${sandbox ? Apis.baseUrlSandbox : Apis.baseUrlLive}${Apis.transactionStatus}',
        data: {'transactionId': transactionId},
        options: Options(
          headers: {'x-api-key': apiKey},
          contentType: Headers.jsonContentType,
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      return outcomeOf(response.data);
    } on DioException catch (e) {
      // 4xx bodies carry a status too (e.g. TRANSACTION_NOT_FOUND).
      return e.response != null
          ? outcomeOf(e.response!.data)
          : KkiapayTransactionOutcome.unknown;
    }
  }

  /// Maps an API status payload to an outcome. Exposed for tests.
  static KkiapayTransactionOutcome outcomeOf(dynamic body) {
    final status = body is Map ? '${body['status']}'.toUpperCase() : '';
    switch (status) {
      case '1':
      case 'SUCCESS':
        return KkiapayTransactionOutcome.success;
      case '3':
      case 'FAILED':
        return KkiapayTransactionOutcome.failed;
      case '':
      case 'NULL':
      case 'TRANSACTION_NOT_FOUND':
        return KkiapayTransactionOutcome.unknown;
      default:
        return KkiapayTransactionOutcome.pending;
    }
  }
}
