import 'dart:convert';

import 'dart:ui';

const KKiaPayURL = "https://widget-v2.kkiapay.me";
const baseUrl = 'https://api-dev.kkiapay.me';
const KKiaPayRedirectURL = "http://redirect.kkiapay.me";
const key = "xxxxxxxxxxxxxxxxxxxxxx";

/// API Key */
const callback = 'http://redirect.kkiapay.me';

/// Webhook */
const sdk = "android";
const defaultTheme = "#4E6BFC";
const nColorPrimary = Color(0xffF11C33);
const nColorSecondary = Color(0xff222F5A);
const nColorYellow = Color(0xffE8C145);
const nColorGray1 = Color(0xffF9F9F9);
const nColorGray2 = Color(0xeaeaea);

/// Widget hex color */
const url = "";

/// Widget header image url */
const host = ""; /** package name **/

/// Widget payment Mode
enum PaymentMethod {
  momo,
  card
}

class SdkData {
  /// @Params amount : Payment amount
  /// @Params reason : Payment reason
  /// @Params name : Payment owner
  /// @Params phone : Payment phoneNumber
  /// @Params data : Payment data send by webhook
  /// @Params sandbox : Payment request made in sandbox
  SdkData({
    this.amount,
    this.paymentMethod,
    this.reason,
    this.name,
    this.email,
    this.phone,
    this.data,
    this.sandbox = true,
    this.apikey,
    this.theme = '#4E6BFC',
  });

  final int? amount;
  final reason, name, email, sandbox, phone, data, apikey, theme, paymentMethod;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'paymentmethod': paymentMethod,
      'reason': reason,
      'name': name,
      'email': email,
      'sandbox': sandbox,
      'key': apikey,
      'callback': callback,
      'phone': phone,
      'sdk': sdk,
      'theme': theme,
      'url': url,
      'host': host,
      'data': data
    };
  }

  String toBase64() {
    var json = jsonEncode(this.toMap());
    var bytes = utf8.encode(json);
    return base64.encode(bytes);
  }
}