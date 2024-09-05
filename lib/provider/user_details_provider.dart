import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/get_student_model.dart';

class UserDetailProvider with ChangeNotifier {
  // Function to fetch student details
  Future<Data> fetchStudentDetails(String studentId) async {
    final url = Uri.parse('http://gujele.in/devdandiya/api/student_details');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'student_id': studentId,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return Data.fromJson(jsonResponse['data']);
        } else {
          throw Exception('Failed to load student details');
        }
      } else {
        throw Exception('Failed to load student details');
      }
    } catch (error) {
      rethrow;
    }
  }
}
