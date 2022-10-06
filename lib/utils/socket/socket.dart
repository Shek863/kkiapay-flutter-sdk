import 'package:kkiapay_flutter_sdk/utils/kkiapayConf.sample.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../kkiapay/data/remote/pos_apis.dart';

late IO.Socket mSocket;

class KSocket {

  late Map query;

  final String tag = "MySocket";

  KSocket ({Map? queryN, required String baseUrl }) {
    query = queryN!;

    try {

      String endPoint = baseUrl;

      mSocket =  IO.io(endPoint, OptionBuilder().setPath("/api/events")
          .setPath("/websocket")
          .enableForceNew()
          .disableReconnection()
          .disableAutoConnect()
          .setQuery(query)
          .setTransports(['websocket']).build());

      mSocket.on('connect_error', (_) =>  Utils.log.d(tag,"connect_error:: $_ "));
      mSocket.on('error', (_) =>  Utils.log.d(tag,"error:: $_ "));
      mSocket.on('safety', (_) =>  Utils.log.d(tag,"safety:: $_ "));

    } catch (e) {
      Utils.log.d(tag,"Failed to init MySocket:: $e ");
    }
  }

  void onPaymentBack ( Function(bool status, String transactionId) onPaymentBack ) {
    Utils.log.d(tag,">>> onPaymentBack");
    mSocket.on('payment_back', (data) {
      try {
        Utils.log.d(tag,"data:: $data ");
        onPaymentBack(data["isPaymentSucces"],data["transactionId"]);
      } catch(e) {
        Utils.log.d(tag,"payment_back:: $e ");
      }

    });
  }

  void onDisconnect ( Function() onDisconnect ) {
    Utils.log.d(tag,">>> onDisconnect");
    mSocket.on('disconnect', (_) => Utils.log.d(tag,"connect_error:: $_ "));
  }

  void onConnectError ( Function() onConnectError ) {
    Utils.log.d(tag,">>> onConnectError");
    mSocket.on('connect_error', (_) =>  Utils.log.d(tag,"connect_error:: $_ "));
  }

  void connect ( Function() onConnect ) {
    mSocket.on('connect', (_) =>  onConnect());
    mSocket.connect();
  }

  void onPaymentProcessing ( Function(Map<String, dynamic> metadata, String status, String transactionId) onPaymentProcessing ) {
    Utils.log.d(tag,">>> payment_processing");
    mSocket.on('payment_processing', (data) {
      try {
        Utils.log.d(tag,"payment_processing data:: $data ");
        onPaymentProcessing(data["metadata"],data["status"],data["transactionId"]);
      } catch(e) {
        Utils.log.d(tag,"payment_processing:: $e ");
      }

    });
  }

  void disconnect () {
    Utils.log.d(tag,">>> disconnect");
    mSocket.disconnect();
  }

  bool isConnected() {
    return mSocket.connected;
  }

}