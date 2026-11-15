import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/view/momoPay/momo_pay_view_model.dart' as momo;
import 'package:kkiapay_flutter_sdk/kkiapay/data/repos/transaction_status_checker.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/view/widget_builder_view_model.dart';
import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart';

void main() {
  group('isRedirectUrl', () {
    test('accepts the exact callback host', () {
      expect(WidgetBuilderViewModel.isRedirectUrl('https://redirect.kkiapay.me?transaction_id=abc'), isTrue);
      expect(WidgetBuilderViewModel.isRedirectUrl('http://redirect.kkiapay.me/?transaction_id=abc'), isTrue);
    });
    test('rejects look-alike hosts and other schemes', () {
      expect(WidgetBuilderViewModel.isRedirectUrl('https://redirect.kkiapay.me.evil.com?transaction_id=abc'), isFalse);
      expect(WidgetBuilderViewModel.isRedirectUrl('https://evil.com/redirect.kkiapay.me'), isFalse);
      expect(WidgetBuilderViewModel.isRedirectUrl('javascript:redirect.kkiapay.me'), isFalse);
      expect(WidgetBuilderViewModel.isRedirectUrl('https://widget-v2.kkiapay.me/?eyJ'), isFalse);
    });
  });

  group('TransactionStatusChecker.outcomeOf', () {
    test('maps final statuses', () {
      expect(TransactionStatusChecker.outcomeOf({'status': 'SUCCESS'}), KkiapayTransactionOutcome.success);
      expect(TransactionStatusChecker.outcomeOf({'status': 1}), KkiapayTransactionOutcome.success);
      expect(TransactionStatusChecker.outcomeOf({'status': 'FAILED'}), KkiapayTransactionOutcome.failed);
      expect(TransactionStatusChecker.outcomeOf({'status': '3'}), KkiapayTransactionOutcome.failed);
    });
    test('never reports success for unknown or pending statuses', () {
      expect(TransactionStatusChecker.outcomeOf({'status': 'TRANSACTION_NOT_FOUND'}), KkiapayTransactionOutcome.unknown);
      expect(TransactionStatusChecker.outcomeOf({'status': 'PENDING'}), KkiapayTransactionOutcome.pending);
      expect(TransactionStatusChecker.outcomeOf('oops'), KkiapayTransactionOutcome.unknown);
      expect(TransactionStatusChecker.outcomeOf(null), KkiapayTransactionOutcome.unknown);
    });
  });

  group('SdkData payment methods', () {
    test('sends the method as the paymentMethods list the widget reads', () {
      final map = SdkData(amount: 100, paymentMethod: 'momo').toMap();
      expect(map['paymentMethods'], ['momo']);
      expect(map.containsKey('paymentmethod'), isFalse);
      expect(SdkData(paymentMethod: PaymentMethod.card).toMap()['paymentMethods'], ['card']);
    });
    test('omits paymentMethods when no method is set', () {
      expect(SdkData(amount: 100).toMap().containsKey('paymentMethods'), isFalse);
    });
  });

  group('MoMo describeError', () {
    test('keeps the step, HTTP status and API message only', () {
      final options = RequestOptions(path: '/api/v1/payments/request', headers: {'x-api-key': 'secret'});
      final error = DioException(
        requestOptions: options,
        response: Response(requestOptions: options, statusCode: 400,
            data: {'status': 'INVALID_COUNTRY', 'message': 'Unsupported operator'}),
      );
      final d = momo.WidgetBuilderViewModel.describeError('requestPayment', error);
      expect(d, {'stage': 'requestPayment', 'statusCode': 400,
          'apiStatus': 'INVALID_COUNTRY', 'message': 'Unsupported operator'});
      expect(d.toString(), isNot(contains('secret')));
    });
    test('reports network errors without a response', () {
      final error = DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError);
      expect(momo.WidgetBuilderViewModel.describeError('initSession', error),
          {'stage': 'initSession', 'statusCode': null, 'message': 'connectionError'});
    });
  });
}
