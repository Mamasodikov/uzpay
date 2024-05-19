import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class Params {
  ClickParams? clickParams;
  PaymeParams? paymeParams;

  Params({this.clickParams, this.paymeParams});
}

class ClickParams {
  final String? serviceId;
  final String? merchantId;
  final String? merchantUserId;
  final String? transactionParam;
  Color headerColor;
  String headerTitle;

  ClickParams(
      {required this.transactionParam,
      required this.serviceId,
      required this.merchantId,
      required this.merchantUserId,
      this.headerColor = const Color(0xFF0085FF),
      this.headerTitle = "\"Click\" to'lov tizimi"});
}

class PaymeParams {
  final String? merchantId;
  String accountObject;
  Color headerColor;
  String headerTitle;
  final String? transactionParam;

  PaymeParams(
      {required this.transactionParam,
      required this.merchantId,

      ///Set if you have changed default account object
      this.accountObject = 'ac.order_id',
      this.headerColor = const Color(0xFF00CCCC),
      this.headerTitle = "\"Payme\" to'lov tizimi"});
}
