import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final int? amount;
  final bool status;
  final transactionId;

  const SuccessScreen({required this.status, this.amount, this.transactionId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text( status?
              'PAYMENT SUCCESSFUL':
              'PAYMENT FAILED'),
        ),
        body: Center(
          child: Text( status?
            "Votre paiement de $amount Fcfa a été recu avec succès et l'ID de la transaction est $transactionId":
            "Votre paiement de $amount Fcfa a échoué et l'ID de la transaction est $transactionId",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
