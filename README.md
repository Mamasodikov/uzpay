# UzPay 🇺🇿 💳

**UzPay**  bu **O'zbekistonda** faoliyat olib boradigan to'lov tizimlari orqali **OSON** to'lov qilish imkonini beradigan Flutter paketidir.

## Taqdimot

![banner](https://github.com/Mamasodikov/uzpay/blob/b4cb426df9514b9ea085e204775b76f587ed52de/example/screenshots/uzpay_banner.png)

## Xususiyatlari

- To'lovlarni ichki va tashqi brauzer orqali ochish
- Ichki brauzer "header" qismidagi yozuv va rangni sizning ilovangizga moslashtirish
- Tashqi brauzerga shaxsiy menyu bo'limini qo'shish

- Hozirda mavjud to'lov tizimlari:
  - **Click** - (*CLICK BUTTON* - orqali) - [DOCS](https://docs.click.uz/en/click-button/)
  - **Payme** - (*GET so'rovida chek yuborish orqali*) - [DOCS](https://developer.help.paycom.uz/initsializatsiya-platezhey/otpravka-cheka-po-metodu-get/)

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

Asosiy `UzPay` klasimizda bir dona statik metod bor:

```dart
UzPay.doPayment(...);
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
        ));
        
/// Tashqi brauzer orqali to'lov chekini ochish
    UzPay.doPayment(context,
        amount: 5000, // To'ov summasi
        paymentSystem: PaymentSystem.Payme,
        paymentParams: paymentParams,
        browserType: BrowserType.External,

        // Quyida ixtiyoriy parametr
        externalBrowserMenuItem: ChromeSafariBrowserMenuItem(
            id: 1,
            label: 'Dasturchi haqida',
            action: (url, title) {
            launchCustomUrl('https://flutterdev.uz/men-haqimda/'); }));
   ```  

***Eslatma: Agar to'lov summasi Payme kabi tiyinlar bilan kiritilsa, jarayon hisobga olingan, faqat aktual summani kiritasiz, masalan 5000 so'm => amount: 5000***

***Savol va takliflar bo'lsa, tortinmang: https://allmylinks.com/mamasodikov***
