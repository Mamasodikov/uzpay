## 0.0.1

* This is initial release of uzpay package
## 0.0.2+2

* Added deeplink support for payments (opens Click Superapp for Click and Payme app for Payme)

## 0.0.3

* **🆕 NEW FEATURE**: Added `UzPay.generatePaymentQR()` method for generating QR codes containing payment URLs
* **🆕 NEW FEATURE**: Added `UzPay.generatePaymentLink()` method for getting payment URLs as strings
* **🆕 NEW FEATURE**: Added logo support to QR codes with optional `logoImage` and `logoSize` parameters
* **🆕 NEW FEATURE**: Added `logoBackgroundColor` parameter for square background behind logos
* **🆕 NEW FEATURE**: Added `logoPadding` parameter for spacing around logos
* **✨ ENHANCEMENT**: Both new methods support all existing payment systems (Click, Payme, PaymeTest)
* **✨ ENHANCEMENT**: Same parameter validation and error handling as existing `doPayment()` method
* **✨ ENHANCEMENT**: QR codes now support embedded logos with customizable backgrounds and padding
* **✨ ENHANCEMENT**: Logo background is optional - no background if not specified
* **🔧 FIX**: Updated deprecated browser settings API to use new `ChromeSafariBrowserSettings`

## 0.0.3+2

* **🔧 FIX**: Increased QR code resolution from 400x400 to 600x600 pixels for better scanning reliability
* **✨ ENHANCEMENT**: Improved QR code clarity and readability with higher resolution output

## 0.0.3+1

* **🆕 NEW FEATURE**: Added `logoBackgroundRadius` parameter for rounded corners on logo backgrounds
* **✨ ENHANCEMENT**: Improved logo image quality with high-resolution rendering
* **✨ ENHANCEMENT**: Added anti-aliasing and high-quality filtering for sharper logos
* **✨ ENHANCEMENT**: Increased QR code resolution for better scanning reliability