import 'package:dio/dio.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/data/remote/pos_apis.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/data/repos/PaymentRepository.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/model/paymentRequest.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:stacked/stacked.dart';

import '../../../utils/socket/socket.dart';

class WidgetBuilderViewModel extends BaseViewModel {
  late String _channel = "";
  String get channel => _channel;
  void setChannel(String channel) {
    _channel = channel;
    notifyListeners();
  }

  late String _amount = "";
  String get amount => _amount;
  void setAmount(String amount) {
    _amount = amount;
    notifyListeners();
  }

  late String _xPublicKey = '';
  String get xPublicKey => _xPublicKey;
  void setXPublicKey(xPublicKey) {
    _xPublicKey = xPublicKey;
    notifyListeners();
  }

  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;
  void setData(Map<String, dynamic> data) {
    _data = data;
    notifyListeners();
  }

  late DateTime _date = DateTime.now();
  DateTime get date => _date;
  void setDate() {
    _date = DateTime.now();
    notifyListeners();
  }

  late PaymentRequest _paymentRequest = PaymentRequest(
      amount: 0,
      contact: "",
      country: "",
      direct: "",
      email: "",
      firstname: "",
      lastname: "",
      phoneNumber: "",
      fullname: "",
      reason: "",
      partnerId: '');
  PaymentRequest get paymentRequest => _paymentRequest;
  void setPaymentRequest(PaymentRequest paymentRequest) {
    _paymentRequest = paymentRequest;
    notifyListeners();
  }

  late PaymentRequestData _paymentRequestData = PaymentRequestData(
      transactionId: "", internalTransactionId: "", status: "");
  PaymentRequestData get paymentRequestData => _paymentRequestData;
  void setPaymentRequestData(PaymentRequestData paymentRequestData) {
    _paymentRequestData = paymentRequestData;
    notifyListeners();
  }

  Future launch(PaymentRequest paymentRequest,
      Function(Map<String, dynamic>, BuildContext)? callback, context) async {
    setLiveCycleState("INIT");
    setPaymentRequest(paymentRequest);
    if (channel.isEmpty) {
      /// select process switch 'sandbox' value
      /// launchPaymentSandbox(...) if true
      /// launchPaymentLive(...) if false
      if (data['sandbox']) {
        launchPaymentSandbox((object, context) async {
          callback!(object, context);
        }, context);
      } else {
        launchPaymentLive((object, context) async {
          callback!(object, context);
        }, context);
      }
    }
  }

  late var kSocket = KSocket(baseUrl: Apis.baseUrlSandbox);

  /// Payment process
  /// (1) we are using @repoP.getAmountFee :::: to getting real debit amount switch mount and payment methode
  /// (2) we are using @getChannel :::: to getting payment channel to listen payment state
  /// (3) we are using @requestPayment :::: to init view
  ///
  Future launchPaymentSandbox(
      Function(Map<String, dynamic>, BuildContext)? callback, context) async {
    try {
      /** (2) */
      PaymentRepository.initSession(
          xPublicKey, {"amount": paymentRequest.amount, "mode": "SANDBOX"},
          onFailure: (object) {
        _fail(callback, context, 'initSession', object);
      }, onSuccess: (channel) {
        Utils.log.d("PaymentLoadingViewModel>>> claimChannel: onSuccess");

        PaymentRequest paymentRequest0 = paymentRequest;
        paymentRequest0.contact = channel;
        setPaymentRequest(paymentRequest0);
        setChannel(channel);

        // var query = "apikey=${developerAccount.api_key}&contact=${paymentRequest.contact}";
        var query = {"apikey": xPublicKey, "contact": paymentRequest0.contact};
        kSocket = KSocket(queryN: query, baseUrl: Apis.baseUrlSandbox);

        kSocket.onPaymentBack((status, transactionId) {
          setChannel("");
          setDate();

          callback!({
            'requestData': data,
            'transactionId': transactionId,
            'isPaymentSuccess': status
          }, context);

          kSocket.disconnect();
        });

        kSocket.connect(() {
          Utils.log.d("tag>>> onConnect");
          if (kSocket.isConnected()) {
            Utils.log.d("tag>>> isConnected == true");
            /** (3) */
            PaymentRepository.requestPayment(xPublicKey, paymentRequest,
                onFailure: (object) {
              Utils.assertError(object, "");
              _fail(callback, context, 'requestPayment', object);
            }, onSuccess: (paymentRequestData) {
              Utils.log.d("requestPayment>>> onSuccess");
              setPaymentRequestData(paymentRequestData!);
            });
          } else {
            Utils.log.d("tag>>> isNotConnected");
          }
        });
      });
    } catch (e) {
      Utils.log.d("PaymentLoadingViewModel>>> transactions liveData: $e");
    }
  }

  Future launchPaymentLive(
      Function(Map<String, dynamic>, BuildContext)? callback, context) async {
    try {
      /** @before */
      PaymentRepositoryLive.initSession(
          xPublicKey, {"amount": paymentRequest.amount, "mode": "LIVE"},
          onFailure: (object) {
        _fail(callback, context, 'initSession', object);
      }, onSuccess: (channel) {
        Utils.log.d("PaymentLoadingViewModel>>> claimChannel: onSuccess");

        PaymentRequest paymentRequest0 = paymentRequest;
        paymentRequest0.contact = channel;
        Utils.log.d(
          "PaymentLoadingViewModel paymentRequest:::: ${paymentRequest0.toJson()}",
        );
        setPaymentRequest(paymentRequest0);
        setChannel(channel);

        // var query = "apikey=${developerAccount.api_key}&contact=${paymentRequest.contact}";
        var query = {"apikey": xPublicKey, "contact": paymentRequest0.contact};
        kSocket = KSocket(queryN: query, baseUrl: Apis.baseUrlLive);

        kSocket.onPaymentBack((status, transactionId) {
          setChannel("");
          setDate();
          if (liveCycleState != "FINISH") {
            setLiveCycleState("FINISH");
            callback!({
              'requestData': data,
              'transactionId': transactionId,
              'isPaymentSuccess': status
            }, context);
          }
          kSocket.disconnect();
        });

        kSocket.connect(() {
          Utils.log.d("tag>>> onConnect");
          if (kSocket.isConnected()) {
            Utils.log.d("tag>>> isConnected");
            PaymentRepositoryLive.requestPayment(xPublicKey, paymentRequest,
                onFailure: (object) {
              Utils.assertError(object, "");
              _fail(callback, context, 'requestPayment', object);
            }, onSuccess: (paymentRequestData) async {
              Utils.log.d("requestPayment>>> onSuccess");
              setPaymentRequestData(paymentRequestData!);

              await Future.delayed(const Duration(seconds: 20));
              if (liveCycleState != "FINISH") {
                PaymentRepository.getPaymentStatus(
                    xPublicKey, paymentRequestData.transactionId, () async {
                  await Future.delayed(const Duration(seconds: 5));
                  if (liveCycleState != "FINISH") {
                    PaymentRepository.getPaymentStatus(
                        xPublicKey, paymentRequestData.transactionId, () {},
                        (isSuccess) {
                      setLiveCycleState("FINISH");
                      callback!({
                        'requestData': data,
                        'transactionId': paymentRequestData.transactionId,
                        'isPaymentSuccess': isSuccess
                      }, context);
                    });
                  }
                }, (isSuccess) {
                  setLiveCycleState("FINISH");
                  callback!({
                    'requestData': data,
                    'transactionId': paymentRequestData.transactionId,
                    'isPaymentSuccess': isSuccess
                  }, context);
                });
              }
            });
          } else {
            Utils.log.d("tag>>> isNotConnected");
          }
        });
      });
    } catch (e) {
      Utils.log.d("PaymentLoadingViewModel>>> transactions liveData: $e");
    }
  }

  /// Ends the flow with a failure the integrator can see. Opening the
  /// session or sending the request used to fail silently (the page waited
  /// forever) or with an empty result and no reason.
  void _fail(Function(Map<String, dynamic>, BuildContext)? callback, context,
      String stage, Object error) {
    if (liveCycleState == "FINISH") return;
    setLiveCycleState("FINISH");
    callback?.call({
      'requestData': data,
      'transactionId': '',
      'isPaymentSuccess': false,
      'error': describeError(stage, error),
    }, context);
  }

  /// Error details safe to log: the failing step, the HTTP status and the
  /// API's own status/message. No headers (api key) and no request body
  /// (customer data). Exposed for tests.
  static Map<String, dynamic> describeError(String stage, Object error) {
    if (error is DioException) {
      final body = error.response?.data;
      return {
        'stage': stage,
        'statusCode': error.response?.statusCode,
        if (body is Map && body['status'] != null) 'apiStatus': '${body['status']}',
        if (body is Map && body['message'] != null) 'message': '${body['message']}',
        if (error.response == null) 'message': error.type.name,
      };
    }
    return {'stage': stage, 'message': error.runtimeType.toString()};
  }

  late String _liveCycleState = "INIT";
  String get liveCycleState => _liveCycleState;
  void setLiveCycleState(String value) {
    _liveCycleState = value;
    notifyListeners();
  }

  @override
  void onDispose() {
    setChannel("");
    try {
      kSocket.disconnect();
    } catch (e) {
      Utils.log.e(e);
    }
    super.dispose();
  }
}
