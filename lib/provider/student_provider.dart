// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dev_dandiya/provider/location_provider.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import '../model/search_model.dart';
import '../model/student_model.dart';

class StudentProvider with ChangeNotifier {
  bool isLoading = false;
  String code = '';
  List<Data> searchList = [];
  bool _isSearchLoading = false;

  bool get isSearchLoading => _isSearchLoading;

  StudentProvider(BuildContext context) {
    getCode(context,
        studentSession: DateTime.now().year.toString(), studentGender: 'Male');
  }

  Future<void> insertStudent(Student student, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('http://gujele.in/devdandiya/api/insert_student');
      var request = http.MultipartRequest('POST', url);

      await getCode(
        context,
        studentSession: student.studentSession,
        studentGender: student.studentGender,
      );
      request.fields['student_name'] = student.studentName;
      request.fields['student_mobile'] = student.studentMobile;
      request.fields['student_gender'] = student.studentGender;
      request.fields['student_code'] = code;
      request.fields['student_session'] = student.studentSession;
      request.fields['student_location'] = student.studentLocation;
      // Check if a profile image is provided
      if (student.studentProfile.isNotEmpty) {
        var file = File(student.studentProfile);
        if (await file.exists()) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'student_profile',
              file.readAsBytesSync(),
              filename: file.path.split('/').last,
            ),
          );
        }
      } else {
        // If no profile is provided, use a default asset image based on gender
        String assetPath;
        if (student.studentGender.toLowerCase() == 'male') {
          assetPath = 'assets/male.png';
        } else {
          assetPath = 'assets/female.png';
        }

        // Load the asset image
        final byteData = await rootBundle.load(assetPath);
        final imageBytes = byteData.buffer.asUint8List();

        // Add the asset image to the request
        request.files.add(
          http.MultipartFile.fromBytes(
            'student_profile',
            imageBytes,
            filename: 'default_profile.png',
          ),
        );
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody.body);
        if (responseData['status'] == 'success') {
          showSnackBar(
            context,
            responseData['message'] ?? 'Student added successfully',
            const Color(0xffffa89e),
          );
          initializeData(context);
          Navigator.pop(context);
        } else {
          showSnackBar(
            context,
            responseData['message'] ?? 'Failed to add student',
            Colors.red,
          );
        }
      } else {
        showSnackBar(
          context,
          jsonDecode(responseBody.body)['message'] ?? 'Failed to add student',
          Colors.red,
        );
      }
    } catch (e) {
      showSnackBar(
        context,
        'Failed to add student: $e',
        Colors.red,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStudent(
    String studentId,
    Student student,
    BuildContext context,
  ) async {
    try {
      final url = Uri.parse('http://gujele.in/devdandiya/api/update_student');
      var request = http.MultipartRequest('POST', url);

      // Add fields to the request
      request.fields['student_id'] = studentId;
      request.fields['student_name'] = student.studentName;
      request.fields['student_mobile'] = student.studentMobile;
      request.fields['student_gender'] = student.studentGender;
      request.fields['student_code'] = code;
      request.fields['student_session'] = student.studentSession;
      request.fields['student_location'] = student.studentLocation;

      if (Uri.tryParse(student.studentProfile)?.isAbsolute ?? false) {
        // If the profile is an HTTP URL, download the file
        final response = await http.get(Uri.parse(student.studentProfile));
        if (response.statusCode == 200) {
          // Convert the downloaded image bytes into a file type
          final fileName = student.studentProfile.split('/').last;
          request.files.add(
            http.MultipartFile.fromBytes(
              'student_profile',
              response.bodyBytes,
              filename: fileName,
            ),
          );
        } else {
          throw Exception('Failed to download the image from URL.');
        }
      } else {
        var file = File(student.studentProfile);
        if (await file.exists()) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'student_profile',
              file.readAsBytesSync(),
              filename: file.path.split('/').last,
            ),
          );
        } else {
          throw Exception('Local file does not exist.');
        }
      }
      await request.send();
    } catch (e) {
      showSnackBar(
        context,
        'Failed to update student: $e',
        Colors.red,
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String studentId, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse(
          'http://gujele.in/devdandiya/api/delete_student'); // Correct API URL
      var request = http.MultipartRequest('POST', url);

      // Add the student ID as a form field
      request.fields['student_id'] = studentId;

      await request.send();
    } catch (e) {
      showSnackBar(
        context,
        'Failed to delete student: $e',
        Colors.red,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchStudent(
    String studentName,
    String studentMobile,
    String studentGender,
    String studentCode,
    String studentSession,
    BuildContext context,
  ) async {
    try {
      _isSearchLoading = true;
      notifyListeners();
      final url = Uri.parse(
          'http://gujele.in/devdandiya/api/search_student'); // Correct API URL
      var request = http.MultipartRequest('POST', url);
      String location = Provider.of<LocationProvider>(context, listen: false)
              .getSelectedLocation()
              ?.locationId ??
          '1';
      // Add parameters to form data
      request.fields['student_name'] = studentName;
      request.fields['student_mobile'] = studentMobile;
      request.fields['student_gender'] =
          studentGender == "Gender" ? "" : studentGender;
      request.fields['student_code'] = studentCode;
      request.fields['student_session'] =
          studentSession == "Year" ? "" : studentSession;
      request.fields['student_location'] = location;

      // Send the request and get the response
      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody.body);

        if (responseData['status'] == 'success') {
          // Convert the response to SearchModel
          SearchModel searchModel = SearchModel.fromJson(responseData);
          showSnackBar(
            context,
            responseData['message'] ?? 'Student found successfully',
            const Color(0xffffa89e),
          );
          searchList = searchModel.data ?? [];
        } else {
          searchList = [];
          showSnackBar(
            context,
            responseData['message'] ?? 'Student not found',
            Colors.red,
          );
        }
      } else {
        showSnackBar(
          context,
          jsonDecode(responseBody.body)['message'] ?? 'Student not found',
          Colors.red,
        );
      }
    } catch (e) {
      showSnackBar(
        context,
        'Failed to search student: $e',
        Colors.red,
      );
    } finally {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCode(BuildContext context,
      {String studentSession = '2024', String studentGender = "Male"}) async {
    try {
      final url = Uri.parse(
          'http://gujele.in/devdandiya/api/get_code'); // Correct API URL
      var request = http.MultipartRequest('POST', url);

      // Add the parameters as form data fields
      request.fields['student_session'] = studentSession;
      request.fields['student_gender'] = studentGender;

      // Send the request and get the response
      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(responseBody.body);

        if (responseData['status'] == 'success') {
          // Handle success, e.g., extracting the student code
          code = responseData['student_code'].toString();
          log(code);
        }
      }
    } catch (e) {
      throw Exception('Failed to get code: $e');
    } finally {
      notifyListeners();
    }
  }

  // Function to strip HTML tags
  String stripHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}
