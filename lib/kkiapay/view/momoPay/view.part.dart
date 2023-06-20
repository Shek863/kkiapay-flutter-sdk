import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'momo_pay_view_model.dart';

class LoadingView extends ViewModelWidget<WidgetBuilderViewModel> {
  LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetBuilderViewModel viewModel) {
    return Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: 104,
              ),
              RichText(
                  text: new TextSpan(
                style: new TextStyle(
                  fontSize: 18.0,
                ),
                children: <TextSpan>[
                  new TextSpan(
                      text: 'Chargement',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  new TextSpan(
                      text: '...',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54)),
                ],
              )),
            ],
          ),
        ));
  }
}

class WidgetBuild extends ViewModelWidget<WidgetBuilderViewModel> {
  final Function(Map<String, dynamic>, BuildContext) callback;
  final String url;

  const WidgetBuild({Key? key, required this.url, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetBuilderViewModel viewModel) {

    WebViewController controller = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return WebViewWidget(controller: controller);
  }
}
