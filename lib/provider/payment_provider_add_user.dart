// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum Gender { male, female }

enum PaymentMethod { cash, online }

enum PaymentType { monthly, yearly }

class GenderProvider with ChangeNotifier {
  Gender _selectedGender = Gender.male;

  Gender get selectedGender => _selectedGender;

  void setGender(Gender gender) {
    _selectedGender = gender;
    notifyListeners();
  }
}

class PaymentMethodProvider with ChangeNotifier {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;

  void setPaymentMethod(PaymentMethod paymentMethod) {
    _selectedPaymentMethod = paymentMethod;
    notifyListeners();
  }
}

class PaymentTypeProvider with ChangeNotifier {
  PaymentType _selectedPaymentType = PaymentType.monthly;

  PaymentType get selectedPaymentType => _selectedPaymentType;

  void setPaymentType(PaymentType paymentType) {
    _selectedPaymentType = paymentType;
    notifyListeners();
  }
}

