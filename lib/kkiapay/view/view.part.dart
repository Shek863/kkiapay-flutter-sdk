import 'package:flutter/material.dart';
import 'package:kkiapay_flutter_sdk/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'widget_builder_view_model.dart';

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
                  child: Center(
                    child: TweenAnimationBuilder(
                      duration: Duration(seconds: 3),
                      tween: SizeTween(
                          begin: Size(65, 65), end: viewModel.newSize),
                      curve: Curves.bounceIn,
                      onEnd: () {
                        viewModel.setNewSize(viewModel.newSize == Size(95, 95)
                            ? Size(65, 65)
                            : Size(95, 95));
                      },
                      builder: (_, Size? size, child) {
                        return Container(
                          width: size?.width,
                          height: size?.height,
                          child: child,
                        );
                      },
                      child: imageFromBase64String(),
                    ),
                  )),
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

/// Hosts the KkiaPay web widget.
///
/// The [WebViewController] is created once, in [State.initState]. It used to
/// be created (and the page reloaded) in `build()`, which runs on every
/// `notifyListeners()` of [WidgetBuilderViewModel]: the loading animation
/// (every ~3 s) and `onPageStarted` itself, so the page reloaded forever.
class WidgetBuild extends StatefulWidget {
  final Function(Map<String, dynamic>, BuildContext) callback;
  final String url;
  final WidgetBuilderViewModel viewModel;

  const WidgetBuild({
    Key? key,
    required this.url,
    required this.callback,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<WidgetBuild> createState() => _WidgetBuildState();
}

class _WidgetBuildState extends State<WidgetBuild> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final viewModel = widget.viewModel;
    _controller = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => viewModel.onPageStarted(url),
          onPageFinished: (url) => viewModel.onPageFinished(url),
          onWebResourceError: (error) {
            Utils.log.w('KkiaPay widget: ${error.errorCode} ${error.description}');
            // Show the webview (and its error page) instead of an endless
            // loader when the widget page itself cannot be loaded.
            if (error.isForMainFrame ?? true) viewModel.loadingFinish();
          },
          onNavigationRequest: (NavigationRequest request) =>
              viewModel.onUrlChange(request, (object, context) async {
                widget.callback(object, context);
              }, context),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
