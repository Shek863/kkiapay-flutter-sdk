import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/data/repos/PaymentRepository.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/model/paymentRequest.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:stacked/stacked.dart';
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
    setPaymentRequest(paymentRequest);
    if(channel.isEmpty) {
      launchPayment((object, context) async {
        callback!(object, context);
      },context);
    }
  }

  late var kSocket = MySocket();

  /// Payment process
  /// @first we are using @repoP.getAmountFee :::: to getting real debit amount switch mount and payment methode
  /// @before we are using @getChannel :::: to getting payment channel to listen payment state
  /// And @finally we are using @requestPayment :::: to init view
  Future launchPayment( Function(Map<String, dynamic>, BuildContext)? callback, context) async {
    try {
      /** @first */
      /*PaymentRepository.getAmountFee(xPublicKey, xPublicKey,
          AmountFee( details: true, amount: paymentRequest.amount.toString()),
          onFailure: (object ) {  },
          onSuccess: (amount) { setAmount(amount.toString()); });*/

      /** @before */
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
            kSocket = MySocket( queryN: query);

            kSocket.onPaymentBack((status, transactionId) {
              setChannel("");
              setDate();

              callback!( { 'requestData': data, 'transactionId': transactionId, 'isPaymentSuccess': status  }, context);

              if (status) {

              }
              else {

              }
              kSocket.disconnect();
            });

            kSocket.connect(() {
              Utils.log.d("tag",">>> onConnect");
              if(kSocket.isConnected()) {
                Utils.log.d("tag",">>> isConnected");
                PaymentRepository.requestPayment( xPublicKey,
                    paymentRequest,
                    onFailure: (object ) {
                      Utils.log.d("requestPayment",">>> onFailure");
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
