// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dev_dandiya/Screen/home_screen.dart';
import 'package:dev_dandiya/const/base_url.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UpdateLoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String _message = '';

  bool get isLoading => _isLoading;
  String get message => _message;

  Future<void> updateLogin({
    required String loginId,
    required String loginName,
    required String loginPassword,
    required BuildContext context,
  }) async {
    final url = Uri.parse('http://gujele.in/devdandiya/api/update_login');
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields['login_id'] = loginId;
      request.fields['login_name'] = loginName;
      request.fields['login_password'] = loginPassword;
      // Send the request
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        if (data['status'] == 'success') {
          _message = data['message'];
          HomeScreen.adminUsername = loginName;
          prefs.setString('admin_username', loginName);
          prefs.setString('admin_password', loginPassword);
          showSnackBar(context, _message, const Color(0xffffa89e));

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          _message = 'Failed to update login: ${data['message']}';
          showSnackBar(context, _message, Colors.red);
        }
      } else {
        _message = 'Server error: ${response.statusCode}';
        showSnackBar(context, _message, Colors.red);
      }
    } catch (e) {
      _message = 'An error occurred: $e';
      showSnackBar(context, _message, Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
