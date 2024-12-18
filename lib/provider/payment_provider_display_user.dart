// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:dev_dandiya/Screen/home_screen.dart';
import 'package:dev_dandiya/model/payment_list_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widget/text_style.dart';

enum PaymentStatus { New, Renew }

enum PaymentType { Monhlty, Yearly }

enum PaymentMethod { Cash, Online }

class PaymentProvider with ChangeNotifier {
  List<Data> _payments = [];
  List<Data> get payments => _payments;
  PaymentStatus _paymentStatus = PaymentStatus.New;
  PaymentType _paymentType = PaymentType.Monhlty;
  PaymentMethod _paymentMethod = PaymentMethod.Cash;
  bool _isLoading = false;
  String _monthlyPayment = '';
  String _yearlyPayment = "";

  PaymentProvider() {
    fetchPayment();
  }
  void setMonthlyPayment(String amount) {
    _monthlyPayment = amount;
    notifyListeners();
  }

  void setYearlyPayment(String amount) {
    _yearlyPayment = amount;
    notifyListeners();
  }

  String get monthlyPayment => _monthlyPayment;
  String get yearlyPayment => _yearlyPayment;

  bool get isLoading => _isLoading;

  PaymentStatus get paymentStatus => _paymentStatus;
  PaymentType get paymentType => _paymentType;
  PaymentMethod get paymentMethod => _paymentMethod;

  void setPaymentStatus(PaymentStatus status) {
    _paymentStatus = status;
    notifyListeners();
  }

  void setPaymentType(PaymentType type) {
    _paymentType = type;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  Future<void> insertPayment(
      {required String studentId,
      required String locationId,
      required String studentSession,
      required String studentType,
      required String paymentType,
      required String paymentMethod,
      required String paymentAmount,
      required String paymentDate,
      required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('http://gujele.in/devdandiya/api/insert_payment');

    final request = http.MultipartRequest('POST', url);

    // Add form fields
    request.fields['student_id'] = studentId;
    request.fields['location_id'] = locationId;
    request.fields['student_session'] = studentSession;
    request.fields['student_type'] = studentType;
    request.fields['payment_type'] = paymentType;
    request.fields['payment_method'] = paymentMethod;
    request.fields['payment_amount'] = paymentAmount;
    request.fields['payment_date'] = paymentDate;

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      final data = json.decode(responseBody.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'success') {
          showSnackBar(context, data['message'], const Color(0xffffa89e));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          showSnackBar(context, data['message'], Colors.red);
        }
      } else {
        showSnackBar(context, "Server Error: ${data['message']}", Colors.red);
      }
    } catch (e) {
      showSnackBar(context, "An Error Occurred: ${e.toString()}", Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Data>> fetchPayments(
      String studentId, BuildContext context) async {
    final url = Uri.parse('http://gujele.in/devdandiya/api/list_payments');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['student_id'] = studentId;

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        PaymentListModel paymentList = PaymentListModel.fromJson(jsonData);
        if (paymentList.status == 'success') {
          _payments = paymentList.data ?? [];
          return _payments;
        } else {
          _payments = [];
          return _payments;
        }
      } else {
        _payments = [];
        return _payments;
      }
    } catch (error) {
      print('Error fetching payments: $error');
    }

    return [];
  }

  Future<void> deletePaynment(String paymentId, BuildContext context) async {
    final url = Uri.parse('http://gujele.in/devdandiya/api/delete_payments');
    var request = http.MultipartRequest('POST', url);

    request.fields['payment_id'] = paymentId;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);

        if (jsonData['status'] == 'success') {
          _payments
              .removeWhere((payment) => payment.studentPaymentId == paymentId);
          showSnackBar(context, jsonData['message'], const Color(0xffffa89e));
        } else {
          showSnackBar(context, jsonData['message'], Colors.red);
        }
      } else {
        showSnackBar(
            context, "Server Error: ${response.reasonPhrase}", Colors.red);
      }
    } catch (e) {
      print('Error deleting payment: $e');
    } finally {
      notifyListeners();
    }
  }

  // http://gujele.in/devdandiya/api/payment
  Future<void> fetchPayment() async {
    final url = Uri.parse('http://gujele.in/devdandiya/api/payment');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'].first;

        if (jsonData['status'] == 'success') {
          _monthlyPayment = data['monthly_payment'].toString();
          _yearlyPayment = data['yearly_payment'].toString();
        } else {
          _monthlyPayment = '0';
          _yearlyPayment = '0';
        }
      } else {
        _monthlyPayment = '0';
        _yearlyPayment = '0';
      }
    } catch (error) {
      print('Error fetching payments: $error');
    }
  }
}
