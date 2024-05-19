import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'enums.dart';
import 'objects.dart';

class WebViewPage extends StatefulWidget {
  final double amount;
  final PaymentSystem paymentSystem;
  final Params paymentParams;

  const WebViewPage(
      {Key? key,
      required this.amount,
      required this.paymentSystem,
      required this.paymentParams})
      : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  int? userId;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions? options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
  ));

  PullToRefreshController? pullToRefreshController;
  String url = "";
  URLRequest urlRequest = URLRequest();
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (PaymentSystem.Click == widget.paymentSystem) {
      urlRequest = URLRequest(
          url: WebUri.uri(Uri.https(clickPaymentPath, "/services/pay", {
        'service_id': widget.paymentParams.clickParams?.serviceId,
        'merchant_id': widget.paymentParams.clickParams?.merchantId,
        'amount': widget.amount.toString(),
        'transaction_param': widget.paymentParams.clickParams?.transactionParam,
        'merchant_user_id': widget.paymentParams.clickParams?.merchantUserId
      })));
    } else if (PaymentSystem.Payme == widget.paymentSystem ||
        PaymentSystem.PaymeTest == widget.paymentSystem) {
      String text =
          "m=${widget.paymentParams.paymeParams?.merchantId};ac.${widget.paymentParams.paymeParams?.accountObject}=${widget.paymentParams.paymeParams?.transactionParam};a=${widget.amount * 100}";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(text);

      urlRequest = URLRequest(
          url: WebUri.uri(Uri.https(
              PaymentSystem.PaymeTest == widget.paymentSystem
                  ? paymePaymentTestPath
                  : paymePaymentPath,
              encoded)));
    }

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            options: PullToRefreshOptions(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.paymentSystem == PaymentSystem.Click
                  ? widget.paymentParams.clickParams?.headerTitle ?? ''
                  : widget.paymentParams.paymeParams?.headerTitle ?? '',
              style: TextStyle(fontSize: 16)),
          toolbarHeight: 70,
          centerTitle: true,
          leadingWidth: 40,
          iconTheme: IconThemeData(size: 22, color: Colors.white),
          automaticallyImplyLeading: true,
          backgroundColor: widget.paymentSystem == PaymentSystem.Click
              ? widget.paymentParams.clickParams?.headerColor
              : widget.paymentParams.paymeParams?.headerColor,
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          // TextField(
          //   decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
          //   controller: urlController,
          //   keyboardType: TextInputType.url,
          //   onSubmitted: (value) {
          //     var path = Uri.parse(value).path;
          //     var host = Uri.parse(value).host;
          //     var queryParams = Uri.parse(value).queryParameters;
          //     // print("===========URL: "+queryParams.toString());
          //     webViewController?.loadUrl(
          //         urlRequest:
          //             URLRequest(url: Uri.https(host, path, queryParams)));
          //   },
          // ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: urlRequest,
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) async {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest: (controller, r, request) async {
                    return PermissionRequestResponse(
                        resources: request,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();

                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onLoadError: (controller, request, e, error) {
                    pullToRefreshController?.endRefreshing();
                    CustomToast.showToast('Error: $error');
                    Navigator.pop(context);
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
          // ButtonBar(
          //   alignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     ElevatedButton(
          //       child: Icon(Icons.arrow_back),
          //       onPressed: () {
          //         webViewController?.goBack();
          //       },
          //     ),
          //     ElevatedButton(
          //       child: Icon(Icons.arrow_forward),
          //       onPressed: () {
          //         webViewController?.goForward();
          //       },
          //     ),
          //     ElevatedButton(
          //       child: Icon(Icons.refresh),
          //       onPressed: () {
          //         webViewController?.reload();
          //       },
          //     ),
          //   ],
          // ),
        ])));
  }
}
