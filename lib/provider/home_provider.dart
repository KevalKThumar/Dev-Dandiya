// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:dev_dandiya/model/message_model.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/get_student_model.dart';

class HomeProvider with ChangeNotifier {
  bool _isLoading = true;
  late GetStudent _items;
  late Message message;

  bool get isLoading => _isLoading;
  GetStudent get items => _items;

  List<dynamic> _allStudents = [];
  List<dynamic> _boys = [];
  List<dynamic> _girls = [];

  List<dynamic> get allStudents => _allStudents;
  List<dynamic> get boys => _boys;
  List<dynamic> get girls => _girls;

  void setMessage() async {
    final response =
        await http.get(Uri.parse('http://gujele.in/devdandiya/api/message'));

    if (response.statusCode == 200) {
      message = Message.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> loadData({
    String sessionId = '2024',
    String locationId = '1',
  }) async {
    _isLoading = true;
    notifyListeners();
    setMessage();
    final url = Uri.parse('http://gujele.in/devdandiya/api/get_students');

    // Create a multipart request
    final request = http.MultipartRequest('POST', url);

    // Add fields to the request
    request.fields['student_session'] = sessionId;
    request.fields['student_location'] = locationId;

    // Send the request and get the response
    try {
      final response = await request.send();

      // Get the response body
      final responseBody = await http.Response.fromStream(response);

      // Handle the response
      if (response.statusCode == 200) {
        ('Request successful: ${responseBody.body}');
        _items = GetStudent.fromJson(jsonDecode(responseBody.body));
        _allStudents = (_items.data ?? []).reversed.toList();
        _boys = (_items.maleStudents ?? []).reversed.toList();
        _girls = (_items.femaleStudents ?? []).reversed.toList();
      } else {
        ('Request failed: ${response.statusCode}');
      }
    } catch (e) {
      ('Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadBoyData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate a delay for loading data
    await Future.delayed(const Duration(seconds: 1));

    _allStudents = _boys;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadGirlData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate a delay for loading data
    await Future.delayed(const Duration(seconds: 1));

    _allStudents = _girls;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateMessage(String welcomeMessage, String instructionMessage,
      BuildContext context) async {
    final url = Uri.parse('http://gujele.in/devdandiya/api/updateMessage');

    try {
      // Create a multipart request for form data submission
      var request = http.MultipartRequest('POST', url);
      request.fields['welcome_message'] = welcomeMessage;
      request.fields['instruction_message'] = instructionMessage;

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log(jsonDecode(response.body)['message']);
      notifyListeners();
    } catch (e) {
      showSnackBar(context, 'Error occurred: $e', Colors.red);
    }
  }

  Future<void> refreshData(BuildContext context) async {
    initializeData(context);
  }


}
