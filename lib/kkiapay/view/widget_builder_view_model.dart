import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/data/repos/transaction_status_checker.dart';
import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Values of `response['status']` passed to the `KKiaPay.callback`.
class KkiapayStatus {
  /// Confirmed by the KkiaPay API.
  static const success = 'SUCCESS';

  /// Confirmed failed by the KkiaPay API, or reported failed by the widget.
  static const failed = 'FAILED';

  /// Not final yet (e.g. the customer has not approved on the phone):
  /// verify it later, server side.
  static const pending = 'PENDING';

  /// The customer closed the widget without paying.
  static const cancelled = 'CANCELLED';
}

class WidgetBuilderViewModel extends BaseViewModel {
  WidgetBuilderViewModel({TransactionStatusChecker? statusChecker})
      : _statusChecker = statusChecker ?? TransactionStatusChecker();

  final TransactionStatusChecker _statusChecker;

  Size _newSize = Size(95, 95);
  Size get newSize => _newSize;
  void setNewSize (newSize) {
    _newSize = newSize;
    notifyListeners();
  }

  bool _hide = false;
  bool get hide => _hide;
  void hideWebView () {
    _hide = true;
    notifyListeners();
  }

  bool _onLoading = true;
  bool get onLoading => _onLoading;
  void loadingStart () {
    _onLoading = true;
    notifyListeners();
  }
  void loadingFinish () {
    _onLoading = false;
    notifyListeners();
  }

  /// Set when the widget page itself cannot be loaded (offline, DNS…).
  String? _loadError;
  String? get loadError => _loadError;
  void setLoadError(String? message) {
    _loadError = message;
    _onLoading = false;
    notifyListeners();
  }

  /// Incremented by [retry] to recreate the webview.
  int _attempt = 0;
  int get attempt => _attempt;
  void retry() {
    _attempt++;
    _loadError = null;
    _onLoading = true;
    notifyListeners();
  }

  Map<String,dynamic> _data = {};
  Map<String,dynamic> get data => _data;
  void setData (Map<String,dynamic> data) {
    _data = data;
    notifyListeners();
  }

  /// Public api key, used to check the transaction status. Kept out of
  /// [data], which is returned to the integrator as `requestData`.
  String? _apiKey;
  void setApiKey(String? apiKey) => _apiKey = apiKey;

  /// Last event posted by the widget page on the `SDK_CHANNEL` channel
  /// (PAYMENT_SUCCESS, PAYMENT_FAILED, PAYMENT_ABORTED, CLOSE_WIDGET…).
  String? _lastWidgetEvent;
  bool _completed = false;

  /// Handles a message from the widget page (`SDK_CHANNEL.postMessage`).
  void onWidgetMessage(String message,
      Function(Map<String, dynamic>, BuildContext)? callback, BuildContext context) {
    String? name;
    try {
      final decoded = jsonDecode(message);
      if (decoded is Map) name = decoded['name']?.toString();
    } catch (_) {
      return;
    }
    if (name == null) return;
    _lastWidgetEvent = name;

    // Closing the widget without paying: no redirect follows. After a
    // payment the widget also closes, then redirects: wait for it.
    if (name == 'CLOSE_WIDGET' || name == 'PAYMENT_ABORTED') {
      Future.delayed(const Duration(seconds: 2), () {
        if (_completed) return;
        _completed = true;
        hideWebView();
        callback?.call(
            _result(null, KkiapayStatus.cancelled), context);
      });
    }
  }

  FutureOr<NavigationDecision> onUrlChange (NavigationRequest request,
      Function(Map<String, dynamic>, BuildContext)? callback, BuildContext context) {
    if (!isRedirectUrl(request.url)) return NavigationDecision.navigate;

    if (!_completed) {
      _completed = true;
      hideWebView ();
      loadingStart ();
      final transactionId =
          Uri.parse(request.url).queryParameters['transaction_id'];
      // Resolve asynchronously: the navigation decision must not wait for
      // the status polling.
      unawaited(_resolve(transactionId).then(
          (status) => callback?.call(_result(transactionId, status), context)));
    }
    return NavigationDecision.prevent;
  }

  /// True only for the exact callback host, over http(s). A prefix check
  /// would also match e.g. `redirect.kkiapay.me.example.com`.
  static bool isRedirectUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == KKiaPayRedirectHost;
  }

  Future<String> _resolve(String? transactionId) async {
    final widgetSaysFailed = _lastWidgetEvent == 'PAYMENT_FAILED';
    if (transactionId == null || transactionId.isEmpty || transactionId == 'null') {
      return widgetSaysFailed ? KkiapayStatus.failed : KkiapayStatus.cancelled;
    }
    final apiKey = _apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      // Cannot verify: never report an unverified success.
      return widgetSaysFailed ? KkiapayStatus.failed : KkiapayStatus.pending;
    }
    final outcome = await _statusChecker.check(
      apiKey: apiKey,
      transactionId: transactionId,
      sandbox: data['sandbox'] == true,
    );
    switch (outcome) {
      case KkiapayTransactionOutcome.success:
        return KkiapayStatus.success;
      case KkiapayTransactionOutcome.failed:
        return KkiapayStatus.failed;
      case KkiapayTransactionOutcome.pending:
      case KkiapayTransactionOutcome.unknown:
        return widgetSaysFailed ? KkiapayStatus.failed : KkiapayStatus.pending;
    }
  }

  Map<String, dynamic> _result(String? transactionId, String status) => {
        'requestData': data,
        'transactionId': transactionId,
        'status': status,
        'isPaymentSuccess': status == KkiapayStatus.success,
        'widgetEvent': _lastWidgetEvent,
      };

  // Page URLs are not logged: the widget URL embeds the api key and the
  // customer's data (name, phone, email).
  void onPageStarted (url) {
    loadingStart();
  }

  // The widget shows its own loader while it initialises: hide the SDK one
  // as soon as the page is there.
  void onPageFinished (url) {
    if (_loadError == null) loadingFinish();
  }


  /** Animation */

  double scale = 0;
  AnimationController? controller ;

}
