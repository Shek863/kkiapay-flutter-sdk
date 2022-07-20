import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kkiapay_flutter_sdk/kkiapay/model/paymentRequest.dart';
import 'package:stacked/stacked.dart';
import '../../../utils/kkiapayConf.sample.dart';
import 'momo_pay_view_model.dart';
import 'dart:io';


class KKiaPayMoMo extends StatefulWidget {

  /// Payment model
  final int amount;
  final String? phone;
  final String? data;
  final String? apikey;
  final bool? sandbox;
  final Function(Map<String, dynamic>, BuildContext) callback;
  final String? theme;
  final String? name;
  final String? email;
  final PaymentMethod? paymentMethod;

  /// Custom view for payment process
  final Widget? waitingScreen;


  const KKiaPayMoMo({
    Key? key,
    required this.amount ,
    this.phone,
    this.data,
    this.paymentMethod,
    this.sandbox,
    required this.apikey,
    required this.callback,
    this.theme,
    this.name,
    this.email,

    this.waitingScreen,
  }) : super(key: key);



  @override
  _KKiaPayState createState() => _KKiaPayState(
    this.amount ,
    this.phone,
    this.data,
    this.paymentMethod,
    this.sandbox,
    this.apikey,
    this.callback,
    this.theme,
    this.name,
    this.email,

    this.waitingScreen,
  );

}



class _KKiaPayState extends State<KKiaPayMoMo> with SingleTickerProviderStateMixin {

  final int amount;
  final String? phone;
  final String? data;
  final String? apikey;
  final bool? sandbox;
  final Function(Map<String, dynamic>, BuildContext) callback;
  final String? theme;
  final String? name;
  final String? email;
  final PaymentMethod? paymentMethod;

  /// Custom view for payment process
  final Widget? waitingScreen;



  _KKiaPayState(
      this.amount ,
      this.phone,
      this.data,
      this.paymentMethod,
      this.sandbox,
      this.apikey,
      this.callback,
      this.theme,
      this.name,
      this.email,

      this.waitingScreen,
  );


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WidgetBuilderViewModel>.reactive(
      fireOnModelReadyOnce: true,
      onModelReady: (model) {
        Platform.isIOS ? null : SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light
        ));
        model.setXPublicKey(apikey);
        model.setData ( {
          'amount':amount,
          'phone': phone,
          'data': data,
          'paymentMethod': paymentMethod,
          'sandbox': sandbox,
          'name':name,
          'email': email
        } );
        model.launch( PaymentRequest(
            amount: amount,
            country: 'BJ',
            email: email!,
            firstname: name!,
            lastname: name!,
            phoneNumber: phone!,
            fullname: name!,
            reason: "", contact: '', direct: ''), (object, context) async {
          callback(object, context);
        }, context );
      },
      builder: (context, model, child) =>  waitingScreen ?? Scaffold(
        body:  SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 18),
                    child: Container (
                      decoration: BoxDecoration (
                        color: Colors.white,
                        /*boxShadow: [
                            BoxShadow (
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1.5,
                              blurRadius: 2,
                              offset: const Offset(0, 0.5), // changes position of shadow
                            ),
                          ],*/
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      padding: EdgeInsets.fromLTRB( 16, 24, 16, 0 ),
                      /*child: const ContentBuild(),*/
                    )
                )
              ],
            )
        ),
      ),
      viewModelBuilder: () => WidgetBuilderViewModel(),
    );
  }



}
