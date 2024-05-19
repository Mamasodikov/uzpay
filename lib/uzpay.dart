library uzpay;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uzpay/constants.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';

import 'web_view.dart';

/// Main class
class UzPay {
  static doPayment(BuildContext context,
      {required double amount,
        required PaymentSystem paymentSystem,
        required Params paymentParams,
        required BrowserType browserType,
        ChromeSafariBrowserMenuItem? externalBrowserMenuItem}) async {
    final ChromeSafariBrowser browser = ChromeSafariBrowser();
    if (externalBrowserMenuItem != null) {
      browser.addMenuItem(externalBrowserMenuItem);
    }

    if (browserType == BrowserType.Internal) {
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                WebViewPage(
                  amount: amount,
                  paymentSystem: paymentSystem,
                  paymentParams: paymentParams,
                )),
      );
    } else {
      if (paymentSystem == PaymentSystem.Click
          ? (paymentParams.clickParams?.serviceId != null ||
          paymentParams.clickParams?.merchantId != null ||
          paymentParams.clickParams?.transactionParam != null ||
          paymentParams.clickParams?.merchantUserId != null)
          : (paymentParams.paymeParams?.merchantId != null ||
          paymentParams.paymeParams?.transactionParam != null)) {
        if (Platform.isAndroid) {
          await InAppWebViewController.setWebContentsDebuggingEnabled(false);
        }

        Uri urlRequest = Uri();

        if (PaymentSystem.Click == paymentSystem) {
          urlRequest = Uri.https(clickPaymentPath, "/services/pay", {
            'service_id': paymentParams.clickParams?.serviceId,
            'merchant_id': paymentParams.clickParams?.merchantId,
            'amount': amount.toString(),
            'transaction_param': paymentParams.clickParams?.transactionParam,
            'merchant_user_id': paymentParams.clickParams?.merchantUserId
          });
        } else if (PaymentSystem.Payme == paymentSystem ||
            PaymentSystem.PaymeTest == paymentSystem) {
          String text =
              "m=${paymentParams.paymeParams?.merchantId};ac.${paymentParams
              .paymeParams?.accountObject}=${paymentParams.paymeParams
              ?.transactionParam};a=${amount * 100}";
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          String encoded = stringToBase64.encode(text);

          urlRequest = Uri.https(PaymentSystem.PaymeTest == paymentSystem
              ? paymePaymentTestPath
              : paymePaymentPath, encoded);
        }

        ///Other payments are coming soon...

          browser.open(
              url: urlRequest,
              options: ChromeSafariBrowserClassOptions(
                  android: AndroidChromeCustomTabsOptions(
                      shareState: CustomTabsShareState.SHARE_STATE_OFF),
                  ios: IOSSafariOptions(barCollapsingEnabled: true)));
      } else {
        throw Exception('Invalid params');
      }
    }
  }
}
