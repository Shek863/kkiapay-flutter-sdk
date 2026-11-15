# kkiapay_flutter_sdk

[Kkiapay](https://kkiapay.me) is developer friendly solution that allows you to accept mobile money and credit card payments
in your application or website.

Before using this SDK, make sure you have a right Merchant Account on [Kkiapay](https://kkiapay.me), otherwise [go](https://kkiapay.me)
and create your account is free and without pain :sunglasses:.

## Installation

To use this package :

```yaml
dependencies:
  flutter:
    sdk: flutter
  kkiapay_flutter_sdk:
```

## Usage

```dart
    import 'package:kkiapay_flutter_sdk/kkiapayWebview.dart';
```

##### Initialise the Kkiapay Instance

```dart
final kkiapay = KKiaPay(
    @required callback: Function(Map<String, dynamic> response, BuildContext context),
    @required amount: String,
    @required apikey: String,
    sandbox: bool,
    data: String,
    phone: String,
    name: String,
    theme: dynamic
);

```

##### Create payment webview instance

```dart
final Widget kkiapayWebview = KkiapayWebview(kkiapay)
```

## Example

```dart
import 'package:example/screens/successScreen.dart';
import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapayWebview.dart';

void main() => runApp(App());

void successCallback(response, context) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SuccessScreen( 
              amount: response['amount'],
              transactionId: response['transactionId']
            )),
  );
}

final kkiapay = KKiaPay(
    callback: successCallback,
    amount: '2000',
    sandbox: true,
    data: 'fakedata',
    apikey: 'xxxxxxxxxxxxxxxxxxxxxxx',
    phone: '97000000',
    name: 'JOHN DOE',
    theme: '#2ba359');

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Kkiapay Sample'),
        centerTitle: true,
      ),
      body: KkiapaySample(),
    ));
  }
}

class KkiapaySample extends StatelessWidget {
  const KkiapaySample({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ButtonTheme(
        minWidth: 250.0,
        height: 60.0,
        child: FlatButton(
          color: Color(0xFFE30E25),
          child: Text(
            'Pay Now',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => kkiapay),
            );
          },
        ),
      ),
    );
  }
}

```

### Reference

<table>
<tr><td>Argument</td><td>Type</td><td>Required</td><td>Details</td></tr>
<tr><td>phone</td><td>String</td><td>Yes</td><td>Valid mobile money number to debit. ex : 22967434270 </td></tr>
<tr><td>amount</td><td>Numeric</td><td>Yes</td><td>Amount to debit from user account (XOF) </td></tr>
<tr><td>name</td><td>String</td><td>No</td><td>Client firstname and lastname </td></tr>
<tr><td>paymentMethod</td><td>PaymentMethod</td><td>No</td><td>Set widget payment method </td></tr>
<tr><td>theme</td><td>String</td><td>No</td><td> the hexadecimal code of the color you want to give to your widget </td></tr>
<tr><td>apikey</td><td>String</td><td>Yes</td><td>public api key</td></tr>
<tr><td>sandbox</td><td>Boolean</td><td>No</td><td>The true value of this attribute allows you to switch to test mode</td></tr>
<tr><td>callback</td><td>Function</td><td>Yes</td><td>Called once the payment flow ends, with the verified status (see below)</td></tr>
</table>

```dart


the successCallback function takes two parameters in the following order
- Map<String,dynamic> containing the transaction information

- the context of type BuildContext


```

### Issues and feedback

Please file [issues](https://github.com/kkiapay/kkiapay-flutter-sdk/issues/new)
to send feedback or report a bug. Thank you!

### Payment result

The callback receives `response['status']`, verified with the KkiaPay API
(`POST /api/v1/transactions/status`, public key):

| status | meaning |
|---|---|
| `SUCCESS` | payment confirmed |
| `FAILED` | payment refused or failed |
| `PENDING` | not final yet (e.g. not approved on the phone): check it later |
| `CANCELLED` | the customer closed the widget |

`response['isPaymentSuccess']` is `true` only for `SUCCESS`, and
`response['transactionId']` holds the transaction id. A redirect alone is
never a success: confirm the transaction on your server before delivering.
