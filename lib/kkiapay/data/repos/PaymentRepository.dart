
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import '../../model/paymentRequest.dart';

class PaymentRepository {

  /// we are using [getAmountFee] :::: to getting real debit amount switch payment methode
  /// @return Boolean
  ///
  static Future<void>  getAmountFee( token, xPublicKey, AmountFee amountFee,
      {required Function(int) onSuccess, required Function(Object) onFailure} )
  async {

    try {
      Utils.client.getAmountFee("Bearer $token",xPublicKey, amountFee).then((it) async {
        onSuccess(it.mobile_money_amount.value);
      }).catchError((Object obj) {
        onFailure(obj);
      });
    }
    catch (e) {
       Utils.log.d("completeExceptionally:: ","Cause:: $e ");
    }

  }


  /// we are using [claimChannel] :::: to getting payment channel to listen payment state
  /// @return Boolean
  ///
  static Future<void>  claimChannel( xPublicKey,
      {required Function(String) onSuccess, required Function(Object) onFailure} )
  async {

    try {
      Utils.client.getChannel(xPublicKey).then((it) async {
        onSuccess(it);
      }).catchError((Object obj) {
        onFailure(obj);
      });
    }
    catch (e) {
      Utils.log.d("completeExceptionally:: ","Cause:: $e ");
    }

  }


  /// we are using [requestPayment] :::: to init view
  /// @return Boolean
  ///
  static Future<void>  requestPayment( xPublicKey,
      PaymentRequest paymentRequest,
      {required Function(PaymentRequestData?) onSuccess, required Function(Object) onFailure} )
  async {

    Utils.log.d("PaymentRequest:: ","Cause:: ${paymentRequest.toJson().toString()} ");

    try {
      Utils.client.requestPayment(xPublicKey, paymentRequest).then((it) async {
        onSuccess(it);
      }).catchError((Object obj) {
        onFailure(obj);
      });
    }
    catch (e) {
      Utils.log.d("completeExceptionally:: ","Cause:: $e ");
    }

  }



  /// we are using [requestPayment] :::: to init view
  /// @return Boolean
  ///
  static Future<void>  validate( xPublicKey,
      Validate validate,
      {required Function(PaymentRequestData?) onSuccess, required Function(Object) onFailure} )
  async {

    try {
      Utils.client.validate(xPublicKey, validate).then((it) async {
        onSuccess(it);
      }).catchError((Object obj) {
        onFailure(obj);
      });
    }
    catch (e) {
      Utils.log.d("completeExceptionally:: ","Cause:: $e ");
    }

  }

}
