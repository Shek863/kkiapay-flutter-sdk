import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/data/remote/pos_apis.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/data/repos/PaymentRepository.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/model/paymentRequest.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/socket/socket.dart';


class WidgetBuilderViewModel extends BaseViewModel {

  late String _channel = "";
  String get channel => _channel;
  void setChannel (String channel) {
    _channel = channel;
    notifyListeners();
  }

  late String _amount = "";
  String get amount => _amount;
  void setAmount (String amount) {
    _amount = amount;
    notifyListeners();
  }

  late String _xPublicKey = '';
  String get xPublicKey => _xPublicKey;
  void setXPublicKey (xPublicKey) {
    _xPublicKey = xPublicKey;
    notifyListeners();
  }

  Map<String,dynamic> _data = {};
  Map<String,dynamic> get data => _data;
  void setData (Map<String,dynamic> data) {
    _data = data;
    notifyListeners();
  }

  late DateTime _date = DateTime.now();
  DateTime get date => _date;
  void setDate () {
    _date = DateTime.now();
    notifyListeners();
  }

  late PaymentRequest _paymentRequest = PaymentRequest(amount: 0, contact: "", country: "", direct: "", email: "", firstname: "", lastname: "", phoneNumber: "", fullname: "", reason: "");
  PaymentRequest get paymentRequest => _paymentRequest;
  void setPaymentRequest (PaymentRequest paymentRequest) {
    _paymentRequest = paymentRequest;
    notifyListeners();
  }

  late PaymentRequestData _paymentRequestData = PaymentRequestData(transactionId: "", internalTransactionId: "", status: "");
  PaymentRequestData get paymentRequestData => _paymentRequestData;
  void setPaymentRequestData (PaymentRequestData paymentRequestData) {
    _paymentRequestData = paymentRequestData;
    notifyListeners();
  }

  Future launch(PaymentRequest paymentRequest,
      Function(Map<String, dynamic>, BuildContext)? callback, context) async{
    setLiveCycleState("INIT");
    setPaymentRequest(paymentRequest);
    if(channel.isEmpty) {
      /// select process switch 'sandbox' value
      /// launchPaymentSandbox(...) if true
      /// launchPaymentLive(...) if false
      if(data['sandbox']) {
        launchPaymentSandbox((object, context) async {
          callback!(object, context);
        },context);
      }else{
        launchPaymentLive((object, context) async {
          callback!(object, context);
        },context);
      }
    }
  }

  late var kSocket = KSocket( baseUrl: Apis.baseUrlSandbox);

  /// Payment process
  /// (1) we are using @repoP.getAmountFee :::: to getting real debit amount switch mount and payment methode
  /// (2) we are using @getChannel :::: to getting payment channel to listen payment state
  /// (3) we are using @requestPayment :::: to init view
  ///
  Future launchPaymentSandbox( Function(Map<String, dynamic>, BuildContext)? callback, context) async {
    try {

      /** (2) */
      PaymentRepository.claimChannel( xPublicKey,
          onFailure: (object ) {
            Utils.log.d("PaymentLoadingViewModel",">>> claimChannel: ${object.toString()}");
          },
          onSuccess: (channel) {
            Utils.log.d("PaymentLoadingViewModel",">>> claimChannel: onSuccess");

            PaymentRequest _paymentRequest =  paymentRequest;
            _paymentRequest.contact = channel;
            setPaymentRequest(_paymentRequest);
            setChannel(channel);

            // var query = "apikey=${developerAccount.api_key}&contact=${paymentRequest.contact}";
            var query = {"apikey": xPublicKey, "contact": paymentRequest.contact };
            kSocket = KSocket( queryN: query , baseUrl: Apis.baseUrlSandbox);

            kSocket.onPaymentBack((status, transactionId) {
              setChannel("");
              setDate();

              callback!( { 'requestData': data, 'transactionId': transactionId, 'isPaymentSuccess': status  }, context);

              kSocket.disconnect();
            });

            kSocket.connect(() {
              Utils.log.d("tag",">>> onConnect");
              if(kSocket.isConnected()) {
                Utils.log.d("tag",">>> isConnected == true");
                /** (3) */
                PaymentRepository.requestPayment( xPublicKey,
                    paymentRequest,
                    onFailure: (object ) {
                      Utils.log.d("requestPayment",">>> onFailure");
                      Utils.assertError(object, "");
                      callback!( { 'requestData': data, 'transactionId': '', 'isPaymentSuccess': false  }, context);
                    },
                    onSuccess: (_paymentRequestData) {
                      Utils.log.d("requestPayment",">>> onSuccess");
                      setPaymentRequestData(_paymentRequestData!);
                    });
              } else{
                Utils.log.d("tag",">>> isNotConnected");
              }
            });

          });

    } catch (e) {
      Utils.log.d("PaymentLoadingViewModel",">>> transactions liveData: $e");
    }
  }

  Future launchPaymentLive( Function(Map<String, dynamic>, BuildContext)? callback, context) async {
    try {
      /** @before */
      PaymentRepositoryLive.initSession(xPublicKey,
          {
            "amount": paymentRequest.amount,
            "mode": "LIVE"
          }, onFailure: (object) {
            Utils.log.d("PaymentLoadingViewModel",">>> claimChannel: ${object.toString()}");
          }, onSuccess: (channel) {
            Utils.log.d("PaymentLoadingViewModel",">>> claimChannel: onSuccess");

            PaymentRequest _paymentRequest =  paymentRequest;
            _paymentRequest.contact = channel;
            Utils.log.d("PaymentLoadingViewModel paymentRequest:::: ",_paymentRequest.toJson());
            setPaymentRequest(_paymentRequest);
            setChannel(channel);

            // var query = "apikey=${developerAccount.api_key}&contact=${paymentRequest.contact}";
            var query = {"apikey": xPublicKey, "contact": paymentRequest.contact };
            kSocket = KSocket( queryN: query, baseUrl: Apis.baseUrlLive );

            kSocket.onPaymentBack((status, transactionId) {
              setChannel("");
              setDate();
              if(liveCycleState != "FINISH"){
                setLiveCycleState("FINISH");
                callback!( { 'requestData': data, 'transactionId': transactionId, 'isPaymentSuccess': status  }, context);
              }
              kSocket.disconnect();
            });

            kSocket.connect(() {
              Utils.log.d("tag",">>> onConnect");
              if(kSocket.isConnected()) {
                Utils.log.d("tag",">>> isConnected");
                PaymentRepositoryLive.requestPayment( xPublicKey,
                    paymentRequest,
                    onFailure: (object ) {
                      Utils.log.d("requestPayment",">>> onFailure");
                      Utils.assertError(object, "");
                      callback!( { 'requestData': data, 'transactionId': '', 'isPaymentSuccess': false  }, context);
                    },
                    onSuccess: (_paymentRequestData) async {
                      Utils.log.d("requestPayment",">>> onSuccess");
                      setPaymentRequestData(_paymentRequestData!);

                      await Future.delayed(const Duration(seconds: 20));
                      if(liveCycleState != "FINISH"){
                        PaymentRepository.getPaymentStatus(xPublicKey,
                            _paymentRequestData.transactionId,() async {

                              await Future.delayed(const Duration(seconds: 5));
                              if(liveCycleState != "FINISH"){
                                PaymentRepository.getPaymentStatus(xPublicKey,
                                    _paymentRequestData.transactionId,(){

                                    },
                                        (isSuccess){
                                      setLiveCycleState("FINISH");
                                      callback!( { 'requestData': data,
                                        'transactionId': _paymentRequestData.transactionId,
                                        'isPaymentSuccess': isSuccess  }, context);
                                    });
                              }

                            },
                                (isSuccess){
                              setLiveCycleState("FINISH");
                              callback!( { 'requestData': data,
                                'transactionId': _paymentRequestData.transactionId,
                                'isPaymentSuccess': isSuccess  }, context);
                            });
                      }

                    });
              } else{
                Utils.log.d("tag",">>> isNotConnected");
              }
            });
          });

    } catch (e) {
      Utils.log.d("PaymentLoadingViewModel",">>> transactions liveData: $e");
    }
  }

  late String _liveCycleState = "INIT";
  String get liveCycleState => _liveCycleState;
  void setLiveCycleState(String value) {
    _liveCycleState = value;
    notifyListeners();
  }

  @override
  onDispose() {
    setChannel("");
    try {
      kSocket.disconnect();
    }
    catch(e){ Utils.log.e(e); }
    super.dispose();
  }

}
