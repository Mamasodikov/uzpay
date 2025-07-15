import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';
import 'package:uzpay/uzpay.dart';

/// Example demonstrating the new UzPay methods:
/// - UzPay.generatePaymentQR() - Generate QR code image
/// - UzPay.generatePaymentLink() - Generate payment URL string
class QRExamplePage extends StatefulWidget {
  const QRExamplePage({super.key});

  @override
  State<QRExamplePage> createState() => _QRExamplePageState();
}

class _QRExamplePageState extends State<QRExamplePage> {
  Uint8List? qrCodeBytes;
  String? paymentLink;
  bool isLoading = false;

  // Example payment parameters
  final double amount = 50000.0; // 50,000 UZS
  final String clickServiceId = '38944';
  final String clickMerchantId = '31069';
  final String clickMerchantUserId = '48614';
  final String paymeTestMerchantId = 'YOUR_PAYME_MERCHANT_ID';
  final String transactionId = 'ORDER_123456';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code & Link Generation',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'New UzPay Methods Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Generate QR Code for Click Payment
            ElevatedButton(
              onPressed: isLoading ? null : () => _generateClickQR(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Click Payment QR Code'),
            ),
            const SizedBox(height: 10),

            // Generate QR Code for Click Payment with Logo
            ElevatedButton(
              onPressed: isLoading ? null : () => _generateClickQRWithLogo(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Click QR Code with Logo'),
            ),
            const SizedBox(height: 10),

            // Generate QR Code for Payme Test Payment
            ElevatedButton(
              onPressed: isLoading ? null : () => _generatePaymeTestQR(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Payme Test Payment QR Code'),
            ),
            const SizedBox(height: 10),

            // Generate QR Code for Payme Test Payment with Logo
            ElevatedButton(
              onPressed:
                  isLoading ? null : () => _generatePaymeTestQRWithLogo(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Payme QR Code with Logo'),
            ),
            const SizedBox(height: 10),

            // Generate QR Code with Logo Background
            ElevatedButton(
              onPressed:
                  isLoading ? null : () => _generateQRWithLogoBackground(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate QR with Logo Background & Padding'),
            ),
            const SizedBox(height: 10),

            // Generate QR Code with Rounded Logo Background
            ElevatedButton(
              onPressed:
                  isLoading ? null : () => _generateQRWithRoundedBackground(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate QR with Rounded Background'),
            ),
            const SizedBox(height: 10),

            // Generate Payment Link for Click
            ElevatedButton(
              onPressed: isLoading ? null : () => _generateClickLink(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Click Payment Link'),
            ),
            const SizedBox(height: 10),

            // Generate Payment Link for Payme Test
            ElevatedButton(
              onPressed: isLoading ? null : () => _generatePaymeTestLink(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate Payme Test Payment Link'),
            ),
            const SizedBox(height: 20),

            if (isLoading) const Center(child: CircularProgressIndicator()),

            // Display QR Code
            if (qrCodeBytes != null) ...[
              const Text(
                'Generated QR Code:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.memory(qrCodeBytes!),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Display Payment Link
            if (paymentLink != null) ...[
              const Text(
                'Generated Payment Link:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SelectableText(
                  paymentLink!,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(paymentLink!),
                icon: const Icon(Icons.copy),
                label: const Text('Copy Link to Clipboard'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _generateClickQR() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final clickParams = ClickParams(
        serviceId: clickServiceId,
        merchantId: clickMerchantId,
        merchantUserId: clickMerchantUserId,
        transactionParam: transactionId,
      );

      final params = Params(clickParams: clickParams);

      // First generate the URL to show what it looks like
      final clickUrl = await UzPay.generatePaymentLink(
        amount: amount,
        paymentSystem: PaymentSystem.Click,
        paymentParams: params,
      );

      print('Click URL: $clickUrl'); // Debug output

      final qrBytes = await UzPay.generatePaymentQR(
        amount: amount,
        paymentSystem: PaymentSystem.Click,
        paymentParams: params,
      );

      setState(() {
        qrCodeBytes = qrBytes;
        paymentLink = clickUrl; // Show the URL too
        isLoading = false;
      });

      _showSnackBar('Click QR Code generated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating QR code: $e');
    }
  }

  Future<void> _generatePaymeTestQR() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final paymeParams = PaymeParams(
        merchantId: paymeTestMerchantId,
        transactionParam: transactionId,
      );

      final params = Params(paymeParams: paymeParams);

      // First generate the URL to show what it looks like
      final paymeUrl = await UzPay.generatePaymentLink(
        amount: amount,
        paymentSystem: PaymentSystem.PaymeTest,
        paymentParams: params,
      );

      print('Payme URL: $paymeUrl'); // Debug output

      final qrBytes = await UzPay.generatePaymentQR(
        amount: amount,
        paymentSystem: PaymentSystem.PaymeTest,
        paymentParams: params,
      );

      setState(() {
        qrCodeBytes = qrBytes;
        paymentLink = paymeUrl; // Show the URL too
        isLoading = false;
      });

      _showSnackBar('Payme Test QR Code generated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating QR code: $e');
    }
  }

  Future<void> _generateClickLink() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final clickParams = ClickParams(
        serviceId: clickServiceId,
        merchantId: clickMerchantId,
        merchantUserId: clickMerchantUserId,
        transactionParam: transactionId,
      );

      final params = Params(clickParams: clickParams);

      final link = await UzPay.generatePaymentLink(
        amount: amount,
        paymentSystem: PaymentSystem.Click,
        paymentParams: params,
      );

      setState(() {
        paymentLink = link;
        isLoading = false;
      });

      _showSnackBar('Click payment link generated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating payment link: $e');
    }
  }

  Future<void> _generatePaymeTestLink() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final paymeParams = PaymeParams(
        merchantId: paymeTestMerchantId,
        transactionParam: transactionId,
      );

      final params = Params(paymeParams: paymeParams);

      final link = await UzPay.generatePaymentLink(
        amount: amount,
        paymentSystem: PaymentSystem.PaymeTest,
        paymentParams: params,
      );

      setState(() {
        paymentLink = link;
        isLoading = false;
      });

      _showSnackBar('Payme Test payment link generated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating payment link: $e');
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Link copied to clipboard!');
  }

  Future<void> _generateClickQRWithLogo() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final clickParams = ClickParams(
        serviceId: clickServiceId,
        merchantId: clickMerchantId,
        merchantUserId: clickMerchantUserId,
        transactionParam: transactionId,
      );

      final params = Params(clickParams: clickParams);

      // Load logo from assets for better quality
      final ByteData bytes = await rootBundle.load('assets/click_icon.png');
      final Uint8List assetLogoBytes = bytes.buffer.asUint8List();

      final qrBytes = await UzPay.generatePaymentQR(
        amount: amount,
        paymentSystem: PaymentSystem.Click,
        paymentParams: params,
        logoImage: assetLogoBytes,
        logoSize: 100.0,
        logoBackgroundRadius: 18.0,
        logoBackgroundColor: Colors.white,
        logoPadding: 12.0,
      );

      setState(() {
        qrCodeBytes = qrBytes;
        isLoading = false;
      });

      _showSnackBar('Click QR Code with logo generated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating QR code with logo: $e');
    }
  }

  Future<void> _generatePaymeTestQRWithLogo() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final paymeParams = PaymeParams(
        merchantId: paymeTestMerchantId,
        transactionParam: transactionId,
      );

      final params = Params(paymeParams: paymeParams);

      // Load logo from assets for better quality
      final ByteData bytes = await rootBundle.load('assets/payme_logo.png');
      final Uint8List logoBytes = bytes.buffer.asUint8List();

      final qrBytes = await UzPay.generatePaymentQR(
        amount: amount,
        paymentSystem: PaymentSystem.PaymeTest,
        paymentParams: params,
        logoImage: logoBytes,
        logoSize: 60.0,
        logoBackgroundColor: Colors.white,
        logoPadding: 8.0,
      );

      setState(() {
        qrCodeBytes = qrBytes;
        isLoading = false;
      });

      _showSnackBar('Payme Test QR Code with logo generated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating QR code with logo: $e');
    }
  }

  Future<void> _generateQRWithLogoBackground() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final clickParams = ClickParams(
        serviceId: clickServiceId,
        merchantId: clickMerchantId,
        merchantUserId: clickMerchantUserId,
        transactionParam: transactionId,
      );

      final params = Params(clickParams: clickParams);

      // Create a more complex logo with transparency
      final logoBytes = await _createComplexLogo();

      final qrBytes = await UzPay.generatePaymentQR(
        amount: amount,
        paymentSystem: PaymentSystem.Click,
        paymentParams: params,
        logoImage: logoBytes,
        logoSize: 80.0,
        logoBackgroundColor: Colors.white,
        logoPadding: 16.0,
      );

      setState(() {
        qrCodeBytes = qrBytes;
        isLoading = false;
      });

      _showSnackBar('QR Code with logo background & padding generated!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating QR code: $e');
    }
  }

  Future<void> _generateQRWithRoundedBackground() async {
    setState(() {
      isLoading = true;
      qrCodeBytes = null;
      paymentLink = null;
    });

    try {
      final clickParams = ClickParams(
        serviceId: clickServiceId,
        merchantId: clickMerchantId,
        merchantUserId: clickMerchantUserId,
        transactionParam: transactionId,
      );

      final params = Params(clickParams: clickParams);

      // Create a high-quality logo
      final logoBytes = await _createHighQualityLogo();

      final qrBytes = await UzPay.generatePaymentQR(
        amount: amount,
        paymentSystem: PaymentSystem.Click,
        paymentParams: params,
        logoImage: logoBytes,
        logoSize: 80.0,
        logoBackgroundColor: Colors.white,
        logoPadding: 20.0,
        logoBackgroundRadius: 16.0, // Rounded corners
      );

      setState(() {
        qrCodeBytes = qrBytes;
        isLoading = false;
      });

      _showSnackBar('QR Code with rounded background generated!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar('Error generating QR code: $e');
    }
  }

  Future<Uint8List> _createHighQualityLogo() async {
    // Create a high-resolution logo with better quality
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 200.0; // Higher resolution

    // Create gradient background
    final gradient = ui.Gradient.radial(
      const Offset(size / 2, size / 2),
      size / 3,
      [Colors.blue.shade400, Colors.indigo.shade600],
    );

    final gradientPaint = Paint()..shader = gradient;

    // Draw circle with gradient
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 10,
      gradientPaint,
    );

    // Add a white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 10,
      borderPaint,
    );

    // Add text "UZ"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'UZ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> _createComplexLogo() async {
    // Create a more complex logo with gradient and text
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 100.0;

    // Create gradient background
    final gradient = ui.Gradient.linear(
      const Offset(0, 0),
      const Offset(size, size),
      [Colors.blue.shade600, Colors.purple.shade600],
    );

    final gradientPaint = Paint()..shader = gradient;

    // Draw rounded rectangle with gradient
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, size, size),
        const Radius.circular(12),
      ),
      gradientPaint,
    );

    // Add a border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(2, 2, size - 4, size - 4),
        const Radius.circular(10),
      ),
      borderPaint,
    );

    // Add text "PAY"
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'PAY',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> _createSimpleLogo(Color color) async {
    // Create a simple colored circle as a logo
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const size = 100.0;
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 10,
      paint,
    );

    // Add a white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 10,
      borderPaint,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
