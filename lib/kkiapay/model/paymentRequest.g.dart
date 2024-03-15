// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paymentRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      amount: json['amount'] as int,
      contact: json['contact'] as String,
      country: json['country'] as String,
      direct: json['direct'] as String,
      email: json['email'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      phoneNumber: json['phoneNumber'] as String,
      fullname: json['fullname'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'contact': instance.contact,
      'country': instance.country,
      'direct': instance.direct,
      'email': instance.email,
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'phoneNumber': instance.phoneNumber,
      'fullname': instance.fullname,
      'reason': instance.reason,
    };

CardPaymentRequest _$CardPaymentRequestFromJson(Map<String, dynamic> json) =>
    CardPaymentRequest(
      logo: json['logo'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      callback_url: json['callback_url'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      notifyBySms: json['notifyBySms'] as bool,
      authorized_payment_source:
          (json['authorized_payment_source'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      target: json['target'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CardPaymentRequestToJson(CardPaymentRequest instance) =>
    <String, dynamic>{
      'logo': instance.logo,
      'name': instance.name,
      'amount': instance.amount,
      'callback_url': instance.callback_url,
      'phone': instance.phone,
      'country': instance.country,
      'notifyBySms': instance.notifyBySms,
      'authorized_payment_source': instance.authorized_payment_source,
      'target': instance.target,
      'description': instance.description,
    };

CardStateObjet _$CardStateObjetFromJson(Map<String, dynamic> json) =>
    CardStateObjet(
      notifyBySms: json['notifyBySms'] as bool,
      paid: json['paid'] as bool,
    );

Map<String, dynamic> _$CardStateObjetToJson(CardStateObjet instance) =>
    <String, dynamic>{
      'notifyBySms': instance.notifyBySms,
      'paid': instance.paid,
    };

PaymentRequestData _$PaymentRequestDataFromJson(Map<String, dynamic> json) =>
    PaymentRequestData(
      transactionId: json['transactionId'] as String,
      internalTransactionId: json['internalTransactionId'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$PaymentRequestDataToJson(PaymentRequestData instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'internalTransactionId': instance.internalTransactionId,
      'status': instance.status,
    };

TransactionId _$TransactionIdFromJson(Map<String, dynamic> json) =>
    TransactionId(
      transactionId: json['transactionId'] as String?,
    );

Map<String, dynamic> _$TransactionIdToJson(TransactionId instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
    };

TransactionStatus _$TransactionStatusFromJson(Map<String, dynamic> json) =>
    TransactionStatus(
      status: json['status'],
      amount: json['amount'] as int?,
      fees: json['fees'] as int?,
      reference: json['reference'] as String?,
      externalTransactionId: json['externalTransactionId'] as String?,
      country: json['country'] as String?,
      reason: json['reason'] as String?,
      partnerId: json['partnerId'] as String?,
    );

Map<String, dynamic> _$TransactionStatusToJson(TransactionStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'amount': instance.amount,
      'fees': instance.fees,
      'reference': instance.reference,
      'externalTransactionId': instance.externalTransactionId,
      'country': instance.country,
      'reason': instance.reason,
      'partnerId': instance.partnerId,
    };

CardPaymentRequestData _$CardPaymentRequestDataFromJson(
        Map<String, dynamic> json) =>
    CardPaymentRequestData(
      phone: json['phone'] as String,
      country: json['country'] as String,
      notifyBySms: json['notifyBySms'] as bool,
      id: json['id'] as String,
      name: json['name'] as String,
      internalTransactionId: json['internalTransactionId'] as String,
      status: json['status'] as String,
      key: json['key'] as String,
      is_valid: json['is_valid'] as bool,
      payment_link: json['payment_link'] as String,
    );

Map<String, dynamic> _$CardPaymentRequestDataToJson(
        CardPaymentRequestData instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'country': instance.country,
      'notifyBySms': instance.notifyBySms,
      'id': instance.id,
      'name': instance.name,
      'internalTransactionId': instance.internalTransactionId,
      'status': instance.status,
      'key': instance.key,
      'is_valid': instance.is_valid,
      'payment_link': instance.payment_link,
    };

Validate _$ValidateFromJson(Map<String, dynamic> json) => Validate(
      country: json['country'] as String,
      internalTransactionId: json['internalTransactionId'] as String,
      metadata: json['metadata'] as String,
      otp: json['otp'] as String,
      status: json['status'] as String,
      transactionId: json['transactionId'] as String,
    );

Map<String, dynamic> _$ValidateToJson(Validate instance) => <String, dynamic>{
      'country': instance.country,
      'internalTransactionId': instance.internalTransactionId,
      'metadata': instance.metadata,
      'otp': instance.otp,
      'status': instance.status,
      'transactionId': instance.transactionId,
    };

PaymentRequestDataOrangeMoney _$PaymentRequestDataOrangeMoneyFromJson(
        Map<String, dynamic> json) =>
    PaymentRequestDataOrangeMoney(
      transactionId: json['transactionId'] as int,
      internalTransactionId: json['internalTransactionId'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$PaymentRequestDataOrangeMoneyToJson(
        PaymentRequestDataOrangeMoney instance) =>
    <String, dynamic>{
      'internalTransactionId': instance.internalTransactionId,
      'status': instance.status,
      'transactionId': instance.transactionId,
    };

PaymentRequestDataOrangeMoneyO _$PaymentRequestDataOrangeMoneyOFromJson(
        Map<String, dynamic> json) =>
    PaymentRequestDataOrangeMoneyO(
      transactionId: json['transactionId'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      internalTransactionId: json['internalTransactionId'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$PaymentRequestDataOrangeMoneyOToJson(
        PaymentRequestDataOrangeMoneyO instance) =>
    <String, dynamic>{
      'internalTransactionId': instance.internalTransactionId,
      'metadata': instance.metadata,
      'status': instance.status,
      'transactionId': instance.transactionId,
    };

AmonutFeeData _$AmonutFeeDataFromJson(Map<String, dynamic> json) =>
    AmonutFeeData(
      card_amount: json['card_amount'],
      mobile_money_amount: MobileMoneyAmount.fromJson(
          json['mobile_money_amount'] as Map<String, dynamic>),
      bank_amount: json['bank_amount'],
    );

Map<String, dynamic> _$AmonutFeeDataToJson(AmonutFeeData instance) =>
    <String, dynamic>{
      'card_amount': instance.card_amount,
      'mobile_money_amount': instance.mobile_money_amount,
      'bank_amount': instance.bank_amount,
    };

MobileMoneyAmount _$MobileMoneyAmountFromJson(Map<String, dynamic> json) =>
    MobileMoneyAmount(
      value: json['value'] as int,
      isBorneByMerchant: json['isBorneByMerchant'] as bool,
    );

Map<String, dynamic> _$MobileMoneyAmountToJson(MobileMoneyAmount instance) =>
    <String, dynamic>{
      'value': instance.value,
      'isBorneByMerchant': instance.isBorneByMerchant,
    };

AmountFee _$AmountFeeFromJson(Map<String, dynamic> json) => AmountFee(
      amount: json['amount'] as String,
      details: json['details'] as bool,
    );

Map<String, dynamic> _$AmountFeeToJson(AmountFee instance) => <String, dynamic>{
      'amount': instance.amount,
      'details': instance.details,
    };
