import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';
import 'package:uzpay/uzpay.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

///You need to import this manually if you want to use menu item in ext. browser
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'dialog_skeleton.dart';
import 'dotted_border.dart';
import 'functions.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _controler = TextEditingController();

  ///Don't worry, this package doesn't post your *secrets* to third parties, you can analyse codes :)
  String CLICK_SERVICE_ID = '3XXXX';
  String CLICK_MERCHANT_ID = '2XXXX';
  String CLICK_MERCHANT_USER_ID = '1XXXX';
  String PAYME_MERCHANT_ID = 'REPLACE_WITH_YOURS';
  String TRANS_ID = 'REPLACE_WITH_YOURS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uzbek Payment Systems 🇺🇿💳'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controler,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              decoration: const InputDecoration(
                hintText: "Summani kiriting...",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text("To'lov tizimlari",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => doPayment(
                        amount: _controler.text.isNotEmpty
                            ? double.parse(_controler.text.toString())
                            : 0,
                        paymentSystem: PaymentSystem.Click,
                        paymentParams: Params(
                            clickParams: ClickParams(
                                transactionParam: TRANS_ID,
                                merchantId: CLICK_MERCHANT_ID,
                                serviceId: CLICK_SERVICE_ID,
                                merchantUserId: CLICK_MERCHANT_USER_ID))),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Container(
                            height: 90,
                            // width: 200.w,
                            child: Image.asset(
                              'assets/click_logo.png',
                              width: 120,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => doPayment(
                        amount: _controler.text.isNotEmpty
                            ? double.parse(_controler.text.toString())
                            : 0,
                        paymentSystem: PaymentSystem.Payme,
                        paymentParams: Params(
                            paymeParams: PaymeParams(
                                transactionParam: TRANS_ID,
                                merchantId: PAYME_MERCHANT_ID,
                                accountObject: 'userId'))),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Container(
                            height: 90,
                            // width: 200.w,
                            child: Image.asset(
                              'assets/payme_logo.png',
                              width: 100,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => CustomToast.showToast('Tez orada....'),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Container(
                            height: 90,
                            // width: 200.w,
                            child: Image.asset(
                              'assets/uzcard_logo.png',
                              width: 120,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => CustomToast.showToast('Tez orada....'),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Container(
                            height: 90,
                            // width: 200.w,
                            child: Image.asset(
                              'assets/oson_logo.png',
                              width: 100,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => CustomToast.showToast('Tez orada....'),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Container(
                            height: 90,
                            // width: 200.w,
                            child: Image.asset(
                              'assets/paynet_logo.jpeg',
                              width: 120,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () => CustomToast.showToast('Tez orada....'),
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Container(
                            height: 90,
                            // width: 200.w,
                            child: Image.asset(
                              'assets/upay_logo.png',
                              width: 100,
                              fit: BoxFit.contain,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  doPayment(
      {required double amount,
      required PaymentSystem paymentSystem,
      required Params paymentParams}) async {
    if (amount > 500) {
      showDialog(
          context: context,
          builder: (context) => DialogSkeleton(
                title: 'Brauzer tanlang',
                icon: 'assets/tick-circle.svg',
                color: Theme.of(context).cardTheme.color,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ZoomTapAnimation(
                                    child: Theme(
                                      data: ThemeData(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        scaffoldBackgroundColor:
                                            Theme.of(context).cardTheme.color,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);

                                          var paymentParams = Params(
                                              paymeParams: PaymeParams(
                                                  transactionParam: TRANS_ID,
                                                  merchantId: PAYME_MERCHANT_ID,

                                                  //This fields are optional
                                                  accountObject: 'userId',
                                                  // If changed
                                                  headerColor: Colors.indigo,
                                                  headerTitle:
                                                      "Payme tizimi orqali to'lash"),
                                              clickParams: ClickParams(
                                                  transactionParam: TRANS_ID,
                                                  merchantId: CLICK_MERCHANT_ID,
                                                  serviceId: CLICK_SERVICE_ID,
                                                  merchantUserId:
                                                      CLICK_MERCHANT_USER_ID));

                                          ///Doing payment with external browser
                                          UzPay.doPayment(context,
                                              amount: amount,
                                              paymentSystem:
                                                  PaymentSystem.Click,
                                              paymentParams: paymentParams,
                                              browserType: BrowserType.External,

                                              //This field is optional
                                              externalBrowserMenuItem:
                                                  ChromeSafariBrowserMenuItem(
                                                      id: 1,
                                                      label:
                                                          'Application support',
                                                      action: (url, title) {
                                                         launchCustomUrl(
                                                            'https://t.me/your_support_bot');
                                                      }));
                                        },
                                        child: DottedBorderWidget(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/browsers.png',
                                                    height: 40,
                                                    // color: cFirstColor,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    child: Text(
                                                      'Tashqi brauzer',
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontFamily: 'Medium',
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ZoomTapAnimation(
                              child: Theme(
                                data: ThemeData(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  scaffoldBackgroundColor:
                                      Theme.of(context).cardTheme.color,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);

                                    ///Doing payment with internal browser
                                    UzPay.doPayment(context,
                                        amount: amount,
                                        paymentSystem: paymentSystem,
                                        paymentParams: paymentParams,
                                        browserType: BrowserType.Internal);
                                  },
                                  child: DottedBorderWidget(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'assets/browser.png',
                                              height: 40,
                                              // color: cFirstColor,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 100,
                                              child: Text(
                                                'Ichki brauzer',
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Medium',
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        )
                      ],
                    )),
              ));
    } else {
      CustomToast.showToast("To'lov imkonsiz, minimal summa 500 so'mdan yuqori!");
    }
  }
}
