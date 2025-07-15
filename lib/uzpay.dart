import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uzpay/constants.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'web_view.dart';

/// Main class
class UzPay {
  /// Generate QR code image containing the payment URL
  static Future<Uint8List> generatePaymentQR({
    required double amount,
    required PaymentSystem paymentSystem,
    required Params paymentParams,
    ChromeSafariBrowserMenuItem? externalBrowserMenuItem,
    Uint8List? logoImage,
    double logoSize = 60.0,
    Color? logoBackgroundColor,
    double logoPadding = 8.0,
    double logoBackgroundRadius = 0.0,
  }) async {
    final paymentUrl = await generatePaymentLink(
      amount: amount,
      paymentSystem: paymentSystem,
      paymentParams: paymentParams,
      externalBrowserMenuItem: externalBrowserMenuItem,
    );

    // Create QR painter with optional logo
    ui.Image? logoUiImage;
    if (logoImage != null) {
      // Create logo with background and padding if specified
      if (logoBackgroundColor != null ||
          logoPadding > 0 ||
          logoBackgroundRadius > 0) {
        logoUiImage = await _createLogoWithBackground(
          logoImage,
          logoSize,
          logoBackgroundColor,
          logoPadding,
          backgroundRadius: logoBackgroundRadius,
        );
      } else {
        // Use original logo without background
        final codec = await ui.instantiateImageCodec(logoImage);
        final frame = await codec.getNextFrame();
        logoUiImage = frame.image;
      }
    }

    final qrPainter = QrPainter(
      data: paymentUrl,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
      embeddedImage: logoUiImage,
      embeddedImageStyle: logoUiImage != null
          ? QrEmbeddedImageStyle(
              size: Size(
                  logoSize + (logoPadding * 2), logoSize + (logoPadding * 2)),
            )
          : null,
    );

    // Create a picture recorder to capture the painting
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(400, 400);

    // Paint the QR code
    qrPainter.paint(canvas, size);

    // Convert to image
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());

    // Convert to bytes
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Create logo with background color and padding
  static Future<ui.Image> _createLogoWithBackground(
    Uint8List logoBytes,
    double logoSize,
    Color? backgroundColor,
    double padding, {
    double backgroundRadius = 0.0,
  }) async {
    // Load the original logo with high quality
    final codec = await ui.instantiateImageCodec(
      logoBytes,
      targetWidth:
          (logoSize * 2).toInt(), // Higher resolution for better quality
      targetHeight: (logoSize * 2).toInt(),
    );
    final frame = await codec.getNextFrame();
    final originalLogo = frame.image;

    // Calculate total size including padding
    final totalSize = logoSize + (padding * 2);

    // Use a higher resolution for better quality (2x)
    final devicePixelRatio = 2.0;
    final scaledSize = totalSize * devicePixelRatio;

    // Create a picture recorder to draw the logo with background
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Scale canvas for higher resolution
    canvas.scale(devicePixelRatio, devicePixelRatio);

    // Draw background if provided
    if (backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = backgroundColor
        ..isAntiAlias = true; // Enable anti-aliasing for smoother edges

      if (backgroundRadius > 0) {
        // Draw rounded rectangle background
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, totalSize, totalSize),
            Radius.circular(backgroundRadius),
          ),
          backgroundPaint,
        );
      } else {
        // Draw regular rectangle background
        canvas.drawRect(
          Rect.fromLTWH(0, 0, totalSize, totalSize),
          backgroundPaint,
        );
      }
    }

    // Draw the logo centered with padding
    final logoRect = Rect.fromLTWH(padding, padding, logoSize, logoSize);

    // Use high quality filtering for the logo
    final paint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;

    canvas.drawImageRect(
      originalLogo,
      Rect.fromLTWH(
          0, 0, originalLogo.width.toDouble(), originalLogo.height.toDouble()),
      logoRect,
      paint,
    );

    // Convert to high-resolution image
    final picture = recorder.endRecording();
    final image =
        await picture.toImage((scaledSize).toInt(), (scaledSize).toInt());

    return image;
  }

  /// Generate payment URL as string
  static Future<String> generatePaymentLink({
    required double amount,
    required PaymentSystem paymentSystem,
    required Params paymentParams,
    ChromeSafariBrowserMenuItem? externalBrowserMenuItem,
  }) async {
    String? urlString;

    if (PaymentSystem.Click == paymentSystem) {
      if (paymentParams.clickParams?.serviceId == null ||
          paymentParams.clickParams?.merchantId == null ||
          paymentParams.clickParams?.transactionParam == null ||
          paymentParams.clickParams?.merchantUserId == null) {
        throw Exception('Invalid params');
      }

      final uri = Uri.https(clickPaymentPath, "/services/pay", {
        'service_id': paymentParams.clickParams?.serviceId,
        'merchant_id': paymentParams.clickParams?.merchantId,
        'amount': amount.toString(),
        'transaction_param': paymentParams.clickParams?.transactionParam,
        'merchant_user_id': paymentParams.clickParams?.merchantUserId
      });
      urlString = uri.toString();
    } else if (PaymentSystem.Payme == paymentSystem ||
        PaymentSystem.PaymeTest == paymentSystem) {
      if (paymentParams.paymeParams?.merchantId == null ||
          paymentParams.paymeParams?.transactionParam == null) {
        throw Exception('Invalid params');
      }

      String text =
          "m=${paymentParams.paymeParams?.merchantId};ac.${paymentParams.paymeParams?.accountObject}=${paymentParams.paymeParams?.transactionParam};a=${amount * 100}";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(text);

      final uri = Uri.https(
          PaymentSystem.PaymeTest == paymentSystem
              ? paymePaymentTestPath
              : paymePaymentPath,
          encoded);
      urlString = uri.toString();
    }

    if (urlString == null) {
      throw Exception('Failed to generate payment URL');
    }

    return urlString;
  }

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

    WebUri? urlRequest;

    if (PaymentSystem.Click == paymentSystem) {
      urlRequest = WebUri.uri(Uri.https(clickPaymentPath, "/services/pay", {
        'service_id': paymentParams.clickParams?.serviceId,
        'merchant_id': paymentParams.clickParams?.merchantId,
        'amount': amount.toString(),
        'transaction_param': paymentParams.clickParams?.transactionParam,
        'merchant_user_id': paymentParams.clickParams?.merchantUserId
      }));
    } else if (PaymentSystem.Payme == paymentSystem ||
        PaymentSystem.PaymeTest == paymentSystem) {
      String text =
          "m=${paymentParams.paymeParams?.merchantId};ac.${paymentParams.paymeParams?.accountObject}=${paymentParams.paymeParams?.transactionParam};a=${amount * 100}";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(text);

      urlRequest = WebUri.uri(Uri.https(
          PaymentSystem.PaymeTest == paymentSystem
              ? paymePaymentTestPath
              : paymePaymentPath,
          encoded));
    }

    if (browserType == BrowserType.Internal ||
        browserType == BrowserType.InternalOrDeeplink) {
      if (browserType != BrowserType.InternalOrDeeplink) {
        Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => WebViewPage(
                    amount: amount,
                    paymentSystem: paymentSystem,
                    paymentParams: paymentParams,
                  )),
        );
      } else {
        if (await canLaunchUrl(Uri.parse(urlRequest.toString()))) {
          // Launch the App
          await launchUrl(Uri.parse(urlRequest.toString()),
              mode: LaunchMode.externalNonBrowserApplication);
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => WebViewPage(
                      amount: amount,
                      paymentSystem: paymentSystem,
                      paymentParams: paymentParams,
                    )),
          );
        }
      }
    } else if (browserType == BrowserType.External ||
        browserType == BrowserType.ExternalOrDeepLink) {
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

        ///Other payments are coming soon...

        if (browserType != BrowserType.ExternalOrDeepLink) {
          browser.open(
              url: urlRequest,
              settings: ChromeSafariBrowserSettings(
                  shareState: CustomTabsShareState.SHARE_STATE_OFF,
                  barCollapsingEnabled: true));
        } else {
          if (await canLaunchUrl(Uri.parse(urlRequest.toString()))) {
            // Launch the App
            await launchUrl(Uri.parse(urlRequest.toString()),
                mode: LaunchMode.externalNonBrowserApplication);
          } else {
            browser.open(
                url: urlRequest,
                settings: ChromeSafariBrowserSettings(
                    shareState: CustomTabsShareState.SHARE_STATE_OFF,
                    barCollapsingEnabled: true));
          }
        }
      } else {
        throw Exception('Invalid params');
      }
    }
  }
}
