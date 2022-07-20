import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/view/momoPay/momo_pay_view.dart';
import './successScreen.dart';

void main() => runApp(App());

void successCallback(response, context) {
  print(response);
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SuccessScreen(
        status: response['isPaymentSuccess'],
        amount: response['amount'],
        transactionId: response['transactionId'],
      ),
    ),
  );
}

final kkiapay = KKiaPayMoMo(
  amount: 1,
  phone: '22961877882',
  data: 'hello world',
  sandbox: false,
  apikey: 'e1ae34f2ffc687b243df1435024a60ec326fa75f',
  callback: successCallback,
  name: 'JOHN DOE',
  email: 'yourmail@mail.com',
  theme: "#E30E25",
  //paymentMethod: PaymentMethod.momo, // or PaymentMethod.card
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Kkiapay Sample'),
          centerTitle: true,
        ),
        body: KkiapaySample(),
      ),
    );
  }
}

class KkiapaySample extends StatelessWidget {
  const KkiapaySample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonTheme(
            minWidth: 250.0,
            height: 60.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffF11C33)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
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
          /*ButtonTheme(
            minWidth: 250.0,
            height: 60.0,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFFBBF00)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text(
                'Pay Now Without Widget (for mobile payment only)',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {

              },
            ),
          ),*/
        ],
      )
    );
  }
}
