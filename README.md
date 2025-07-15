# UzPay 🇺🇿 💳

**UzPay**  bu **O'zbekistonda** faoliyat olib boradigan to'lov tizimlari orqali **OSON** to'lov qilish imkonini beradigan Flutter paketidir.

## Taqdimot

![uzpay_banner](https://github.com/Mamasodikov/uzpay/assets/64262986/cf837558-f3cf-4ddf-bd1c-7735db57617f)

## Xususiyatlari

- To'lovlarni ichki va tashqi brauzer orqali ochish
- Ichki brauzer "header" qismidagi yozuv va rangni sizning ilovangizga moslashtirish
- Tashqi brauzerga shaxsiy menyu bo'limini qo'shish
- **🆕 QR kod yaratish** - To'lov havolalarini QR kod sifatida yaratish
- **🆕 Logo bilan QR kod** - QR kod markaziga logo qo'shish imkoniyati
- **🆕 Logo fon rangi va padding** - Logo uchun kvadrat fon va bo'shliq sozlamalari
- **🆕 To'lov havolalarini olish** - Maxsus UI yoki veb integratsiya uchun

- Hozirda mavjud to'lov tizimlari:
  - **Click** - (*CLICK BUTTON - orqali*) - [DOCS](https://docs.click.uz/en/click-button/)
  - **Payme** - (*GET - so'rovida chek yuborish orqali*) - [DOCS](https://developer.help.paycom.uz/initsializatsiya-platezhey/otpravka-cheka-po-metodu-get/)

- Qo'shilishi re'jada turganlari:
  - **Uzcard**
  - **Oson**
  - **Paynet**
  - **Upay**


## Boshlash #

Flutter loyihangizga paket nomini qo'shing:

   ```yaml
   dependencies:
     uzpay: ^x.y.z
   ```  

Ushbu komandani yurgizing:

   ```yaml
   flutter pub get
   ```    
Batafsil, bu yerda o'qing [dokumentatsiya](https://flutter.dev/).

## Ishlatish namunasi
Dart kodingizga paketni import qiling:

   ```yaml
   import 'package:uzpay/uzpay.dart';
   ```  

Asosiy `UzPay` klasimizda uchta statik metod bor:

```dart
UzPay.doPayment(...);           // Brauzer orqali to'lov
UzPay.generatePaymentQR(...);   // QR kod yaratish
UzPay.generatePaymentLink(...); // To'lov havolasini olish
```

Uning ishlatilish tartibi quyidagicha:

   ```dart
   ///Avvaliga parametrlarni belgilab olamiz
var paymentParams = Params(
       paymeParams: PaymeParams(
       transactionParam: TRANS_ID,
       merchantId: PAYME_MERCHANT_ID,

        // Quyidagilar ixtiyoriy parametrlar
        accountObject: 'userId', // Agar o'zgargan bo'lsa
        headerColor: Colors.indigo, // Header rangi
        headerTitle: "Payme tizimi orqali to'lash"), // Header yozuvi
        
        clickParams: ClickParams(
        transactionParam: TRANS_ID,
        merchantId: CLICK_MERCHANT_ID,
        serviceId: CLICK_SERVICE_ID,
        merchantUserId: CLICK_MERCHANT_USER_ID,
        
        // Quyidagilar ixtiyoriy parametrlar
        headerColor: Colors.blue, // Header rangi
        headerTitle: "Click tizimi orqali to'lash"), // Header yozuvi
        );
        
/// Tashqi brauzer orqali to'lov chekini ochish
    UzPay.doPayment(context,
        amount: 5000, // To'lov summasi
        paymentSystem: PaymentSystem.Payme,
        paymentParams: paymentParams,
        browserType: BrowserType.External,
        
        ///browserType: BrowserType.ExternalOrDeepLink (For deeplink)

        // Quyida ixtiyoriy parametr
        externalBrowserMenuItem: ChromeSafariBrowserMenuItem(
            id: 1,
            label: 'Dasturchi haqida',
            action: (url, title) {
            launchCustomUrl('https://flutterdev.uz/men-haqimda/'); }));
   ```  

## Yangi metodlar: QR kod va havola yaratish 🆕

### QR kod yaratish

QR kod yaratish uchun `generatePaymentQR` metodidan foydalaning:

```dart
import 'dart:typed_data';

// Click uchun QR kod yaratish
final clickParams = ClickParams(
  serviceId: 'YOUR_SERVICE_ID',
  merchantId: 'YOUR_MERCHANT_ID',
  merchantUserId: 'YOUR_MERCHANT_USER_ID',
  transactionParam: 'ORDER_123456',
);

final params = Params(clickParams: clickParams);

try {
  final Uint8List qrBytes = await UzPay.generatePaymentQR(
    amount: 50000.0, // 50,000 so'm
    paymentSystem: PaymentSystem.Click,
    paymentParams: params,
  );

  // QR kodni UI da ko'rsatish
  Image.memory(qrBytes);
} catch (e) {
  print('QR kod yaratishda xatolik: $e');
}
```

### Logo bilan QR kod yaratish 🆕

QR kod markaziga logo qo'shish uchun `logoImage` parametridan foydalaning:

```dart
// Logo rasmini yuklash (PNG, JPG formatida)
final Uint8List logoBytes = await rootBundle.load('assets/logo.png')
    .then((data) => data.buffer.asUint8List());

// Logo bilan QR kod yaratish
final Uint8List qrBytes = await UzPay.generatePaymentQR(
  amount: 50000.0,
  paymentSystem: PaymentSystem.Click,
  paymentParams: params,
  logoImage: logoBytes,              // Logo rasmi (ixtiyoriy)
  logoSize: 80.0,                   // Logo o'lchami (ixtiyoriy, standart: 60.0)
  logoBackgroundColor: Colors.white, // Logo fon rangi (ixtiyoriy)
  logoPadding: 12.0,                // Logo atrofidagi bo'shliq (ixtiyoriy, standart: 8.0)
);
```

### Logo parametrlari:

- **`logoImage`**: Logo rasmi (Uint8List formatida, PNG/JPG)
- **`logoSize`**: Logo o'lchami (standart: 60.0)
- **`logoBackgroundColor`**: Logo uchun fon rangi (ixtiyoriy)
- **`logoPadding`**: Logo atrofidagi bo'shliq (standart: 8.0)
- **`logoBackgroundRadius`**: Logo fon burchaklarini yumaloqlash (standart: 0.0 - kvadrat)

### Logo fon rangi va padding misollari:

```dart
// Yumaloq burchakli oq fonli logo (yuqori sifat)
final qrBytes = await UzPay.generatePaymentQR(
  // ... boshqa parametrlar
  logoImage: logoBytes,
  logoSize: 80.0,
  logoBackgroundColor: Colors.white,
  logoPadding: 16.0,
  logoBackgroundRadius: 12.0, // Yumaloq burchaklar
);

// Kvadrat fonli logo
final qrBytes = await UzPay.generatePaymentQR(
  // ... boshqa parametrlar
  logoImage: logoBytes,
  logoSize: 80.0,
  logoBackgroundColor: Colors.white,
  logoPadding: 16.0,
  logoBackgroundRadius: 0.0, // Kvadrat (standart)
);

// Fonsiz logo (faqat padding bilan)
final qrBytes = await UzPay.generatePaymentQR(
  // ... boshqa parametrlar
  logoImage: logoBytes,
  logoSize: 80.0,
  logoPadding: 12.0, // Fon rangi berilmagan, faqat padding
);

// Oddiy logo (fon va padding yo'q)
final qrBytes = await UzPay.generatePaymentQR(
  // ... boshqa parametrlar
  logoImage: logoBytes,
  logoSize: 80.0,
);
```

### Yuqori sifatli logo uchun tavsiyalar:

- **Yuqori piksellik rasm** ishlatish (kamida 200x200 piksel)
- **PNG format** ishlatish (shaffoflik uchun)
- **Oddiy dizayn** (QR kod o'qilishini ta'minlash uchun)
- **Yetarli kontrast** (fon rangi bilan)
- **Yumaloq burchaklar** (zamonaviy ko'rinish uchun)

### To'lov havolasini olish

To'lov havolasini olish uchun `generatePaymentLink` metodidan foydalaning:

```dart
// Payme uchun havola yaratish
final paymeParams = PaymeParams(
  merchantId: 'YOUR_PAYME_MERCHANT_ID',
  transactionParam: 'ORDER_123456',
);

final params = Params(paymeParams: paymeParams);

try {
  final String paymentUrl = await UzPay.generatePaymentLink(
    amount: 25000.0, // 25,000 so'm
    paymentSystem: PaymentSystem.Payme,
    paymentParams: params,
  );

  print('To\'lov havolasi: $paymentUrl');
  // Havolani ulashish yoki boshqa maqsadlarda ishlatish
} catch (e) {
  print('Havola yaratishda xatolik: $e');
}
```

### Foydalanish holatlari

**1. Maxsus UI yaratish:**
```dart
// QR kod yaratib, maxsus dialog da ko'rsatish
final qrBytes = await UzPay.generatePaymentQR(/* parametrlar */);
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('To\'lov uchun skanerlang'),
    content: Image.memory(qrBytes),
  ),
);
```

**2. QR kodni ulashish:**
```dart
// QR kodni fayl sifatida saqlash yoki ulashish
final qrBytes = await UzPay.generatePaymentQR(/* parametrlar */);
// Platform-specific ulashish mexanizmlari orqali ulashish
```

**3. Veb integratsiya:**
```dart
// To'lov havolasini veb ilovalar uchun yaratish
final paymentUrl = await UzPay.generatePaymentLink(/* parametrlar */);
// Veb ilovalar yoki deep linking da ishlatish
```

### Enumlar:

```dart
enum PaymentSystem { Click, Payme, PaymeTest }
enum BrowserType { External, Internal, ExternalOrDeepLink, InternalOrDeeplink }
```

***Eslatma: Agar to'lov summasi Payme kabi tiyinlar bilan kiritilsa, jarayon hisobga olingan, faqat aktual summani kiritasiz, masalan 5000 so'm => amount: 5000***

***Savol va takliflar bo'lsa, tortinmang: https://allmylinks.com/mamasodikov***