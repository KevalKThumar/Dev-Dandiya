// ignore_for_file: use_build_context_synchronously

import 'package:dev_dandiya/const/base_url.dart';
import 'package:dev_dandiya/const/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../Screen/home_screen.dart';
import '../widget/text_style.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login(
      String email, String password, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _setLoading(true);

    final url = '${BaseUrl.url}/login';
    final response = await http.post(Uri.parse(url), body: {
      'username': email,
      'password': password,
    });

    final responseData = json.decode(response.body);

    if (responseData['status'] == 'success') {

      await prefs.setString('auth',"LoggedIn");
      // Storing user data
      await prefs.setString('status', responseData['status']);
      await prefs.setString('message', responseData['message']);
      await prefs.setString('admin_id', responseData['data']['admin_id']);
      await prefs.setString(
          'admin_username', responseData['data']['admin_username']);
      await prefs.setString(
          'admin_password', responseData['data']['admin_password']);
      await prefs.setString(
          'admin_status', responseData['data']['admin_status']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            responseData['message'],
            style: myTextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor,
            ),
          ),
          backgroundColor: const Color(0xff5F259E),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );

      // Navigate to home screen after storing data
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            responseData['message'],
            style: myTextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor,
            ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );
    }

    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
