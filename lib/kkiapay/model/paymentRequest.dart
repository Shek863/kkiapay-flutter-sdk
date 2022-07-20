import 'package:json_annotation/json_annotation.dart';
part 'paymentRequest.g.dart';

@JsonSerializable()
class PaymentRequest{
   int amount;
   String contact = "";
   String country = "";
   String direct = "";
   String email = "";
   String firstname ="";
   String lastname="";
   String phoneNumber;
   String fullname = "";
   String reason = "";

   PaymentRequest({  required this.amount,  required this.contact,  required this.country,  required this.direct,
    required this.email,  required this.firstname,  required this.lastname,  required this.phoneNumber,  required this.fullname,  required this.reason});

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@JsonSerializable()
class CardPaymentRequest{

   String logo = "";
   String name = "";
   int amount;
   String callback_url = "https://kkiapay.me";
   String phone ="";
   String country="";
   bool notifyBySms = true;
   List<String> authorized_payment_source;
   String target = "Professional";
   String description = "Paiement en point de vente";

   CardPaymentRequest({  required this.logo,  required this.name,  required this.amount,  required this.callback_url,
    required this.phone,  required this.country,  required this.notifyBySms,  required this.authorized_payment_source,  required this.target,  required this.description});

  factory CardPaymentRequest.fromJson(Map<String, dynamic> json) => _$CardPaymentRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CardPaymentRequestToJson(this);
}

@JsonSerializable()
class CardStateObjet{

  bool notifyBySms = true;
  bool paid = true;

   CardStateObjet({  required this.notifyBySms, required this.paid});

  factory CardStateObjet.fromJson(Map<String, dynamic> json) => _$CardStateObjetFromJson(json);
  Map<String, dynamic> toJson() => _$CardStateObjetToJson(this);
}

@JsonSerializable()
class PaymentRequestData{

  String transactionId ;
  String internalTransactionId ;
  String status;


  PaymentRequestData({  required this.transactionId, required this.internalTransactionId, required this.status});

  factory PaymentRequestData.fromJson(Map<String, dynamic> json) => _$PaymentRequestDataFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestDataToJson(this);
}

@JsonSerializable()
class CardPaymentRequestData{

  String phone ;
  String country ;
  bool notifyBySms = true;
  String id;
  String name;
  String internalTransactionId;
  String status;
  String key;
  bool is_valid = true;
  String payment_link;

  CardPaymentRequestData({  required this.phone, required this.country, required this.notifyBySms,
    required this.id, required this.name, required this.internalTransactionId,
    required this.status, required this.key, required this.is_valid, required this.payment_link,});

  factory CardPaymentRequestData.fromJson(Map<String, dynamic> json) => _$CardPaymentRequestDataFromJson(json);
  Map<String, dynamic> toJson() => _$CardPaymentRequestDataToJson(this);
}

@JsonSerializable()
class Validate{

  String country="" ;
  String internalTransactionId="" ;
  String metadata="";
  String otp ="";
  String status = "initiated";
  String transactionId ;

  Validate({ required this.country, required this.internalTransactionId, required this.metadata,
    required this.otp, required this.status, required this.transactionId});

  factory Validate.fromJson(Map<String, dynamic> json) => _$ValidateFromJson(json);
  Map<String, dynamic> toJson() => _$ValidateToJson(this);
}

@JsonSerializable()
class PaymentRequestDataOrangeMoney {

  String internalTransactionId ;
  String status;
  int transactionId ;

  PaymentRequestDataOrangeMoney({  required this.transactionId, required this.internalTransactionId, required this.status});

  factory PaymentRequestDataOrangeMoney.fromJson(Map<String, dynamic> json) => _$PaymentRequestDataOrangeMoneyFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestDataOrangeMoneyToJson(this);

}

@Deprecated("old")
@JsonSerializable()
class PaymentRequestDataOrangeMoneyO {

  String internalTransactionId ;
  Map<String,dynamic> metadata;
  String status;
  String transactionId ;

  PaymentRequestDataOrangeMoneyO({  required this.transactionId,required this.metadata, required this.internalTransactionId, required this.status});

  factory PaymentRequestDataOrangeMoneyO.fromJson(Map<String, dynamic> json) => _$PaymentRequestDataOrangeMoneyOFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentRequestDataOrangeMoneyOToJson(this);

}


@JsonSerializable()
class AmonutFeeData {

  var card_amount ;
  MobileMoneyAmount mobile_money_amount;
  var bank_amount ;


  AmonutFeeData({  required this.card_amount, required this.mobile_money_amount, required this.bank_amount});

  factory AmonutFeeData.fromJson(Map<String, dynamic> json) => _$AmonutFeeDataFromJson(json);
  Map<String, dynamic> toJson() => _$AmonutFeeDataToJson(this);

}



@JsonSerializable()
class MobileMoneyAmount {

  int value;
  bool isBorneByMerchant ;

  MobileMoneyAmount({  required this.value, required this.isBorneByMerchant});

  factory MobileMoneyAmount.fromJson(Map<String, dynamic> json) => _$MobileMoneyAmountFromJson(json);
  Map<String, dynamic> toJson() => _$MobileMoneyAmountToJson(this);

}


@JsonSerializable()
class AmountFee {

  String amount = "";
  bool details = true;

  AmountFee({  required this.amount, required this.details});

  factory AmountFee.fromJson(Map<String, dynamic> json) => _$AmountFeeFromJson(json);
  Map<String, dynamic> toJson() => _$AmountFeeToJson(this);

}


