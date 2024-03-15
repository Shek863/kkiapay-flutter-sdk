import 'dart:async';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../model/paymentRequest.dart';
part 'pos_apis.g.dart';

///APIs class is for api tags
class Apis {
  static const String pricingBaseUrl = 'https://api-dev.kkiapay.me/api-pos/api/v1';
  static const String terminals = '/terminals';
  static const String pushRegister = '/push/register-token/{id}';
  static const String paid = '/terminals/paiement/{n}/{id}';
  static const String me = '/auth/me/{terminalId}';

  //static const String baseUrl = 'https://api-dev.kkiapay.me';
  static const String baseUrlSandbox = 'https://api-sandbox.kkiapay.me';
  static const String baseUrlLive = 'https://api.kkiapay.me';

  static const String claimChannel = '/api/v1/utils/claimchannel';
  static const String getAmountFees = '/api/v1/utils/get-amount-with-fees';
  static const String requestPayment = '/api/v1/payments/request';
  static const String validate = '/api/v1/payments/orange-ci/validate';

  static const String transactionStatus = '/api/v1/transactions/status';

}

@RestApi(baseUrl: Apis.baseUrlSandbox)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  /****************************************************************************************************/

  /// Payment Service
  /// first we are using [getAmountFee] :::: to getting real debit amount switch payment methode
  /// before we are using [getChannel] :::: to getting payment channel to listen payment state
  /// And finally we are using [requestPayment] :::: to init view
  ///*/
  @POST(Apis.getAmountFees)
  Future<AmonutFeeData> getAmountFee(
      @Header("authorization") String token,
      @Header("x-api-key") String xPublicKey,
      @Body() AmountFee body,
      { @Header("sdk") String sdk = "POS" });


  @GET(Apis.claimChannel)
  Future<String> getChannel(
      @Header("x-api-key") String xPublicKey,
  { @Header("sdk") String sdk = "POS" });


  @POST(Apis.requestPayment)
  Future<PaymentRequestData> requestPayment(
      @Header("x-api-key") String xPublicKey,
      @Body() PaymentRequest body,
      { @Header("sdk") String sdk = "POS" });


  @POST(Apis.requestPayment)
  Future<PaymentRequestDataOrangeMoney> requestPaymentOrangeMoney(
      @Header("x-api-key") String xPublicKey,
      @Body() PaymentRequest body,
      { @Header("sdk") String sdk = "POS" });


  @POST(Apis.validate)
  Future<PaymentRequestData> validate(
      @Header("x-api-key") String xPublicKey,
      @Body() Validate body,
      { @Header("sdk") String sdk = "POS" });

  /// [Payment] transaction status
  @POST(Apis.transactionStatus)
  Future<TransactionStatus> getTransactionStatus(
      @Header("x-api-key") String xPublicKey,
      @Body() TransactionId body );

}

@RestApi(baseUrl: Apis.baseUrlLive)
abstract class ApiClientLive {
  factory ApiClientLive(Dio dio, {String baseUrl}) = _ApiClientLive;

  /****************************************************************************************************/

  /// Payment Service
  /// first we are using [getAmountFee] :::: to getting real debit amount switch payment methode
  /// before we are using [getChannel] :::: to getting payment channel to listen payment state
  /// And finally we are using [requestPayment] :::: to init view
  ///*/
  @POST(Apis.getAmountFees)
  Future<AmonutFeeData> getAmountFee(
      @Header("authorization") String token,
      @Header("x-api-key") String xPublicKey,
      @Body() AmountFee body,
      { @Header("sdk") String sdk = "POS" });


  @GET(Apis.claimChannel)
  Future<String> getChannel(
      @Header("x-api-key") String xPublicKey,
      { @Header("sdk") String sdk = "POS" });


  @POST(Apis.requestPayment)
  Future<PaymentRequestData> requestPayment(
      @Header("x-api-key") String xPublicKey,
      @Body() PaymentRequest body,
      { @Header("sdk") String sdk = "POS" });


  @POST(Apis.requestPayment)
  Future<PaymentRequestDataOrangeMoney> requestPaymentOrangeMoney(
      @Header("x-api-key") String xPublicKey,
      @Body() PaymentRequest body,
      { @Header("sdk") String sdk = "POS" });


  @POST(Apis.validate)
  Future<PaymentRequestData> validate(
      @Header("x-api-key") String xPublicKey,
      @Body() Validate body,
      { @Header("sdk") String sdk = "POS" });

}