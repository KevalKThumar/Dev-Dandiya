import 'dart:convert';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import '../model/session_model.dart';
import 'package:http/http.dart' as http;

class SessionProvider with ChangeNotifier {
  List<Data> _sessions = [];
  Data? _selectedSession;

  List<Data> get sessions => _sessions;
  Data? get selectedSession => _selectedSession;

  Future<void> fetchSessions() async {
    try {
      final response =
          await http.get(Uri.parse('http://gujele.in/devdandiya/api/session'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Session sessionResponse = Session.fromJson(data);

        _sessions = sessionResponse.data ?? [];
        _selectedSession = _sessions.isNotEmpty ? _sessions[1] : null;
      }
    } catch (e) {
      throw Exception(
          'Failed to load sessions:- ${stripHtmlTags(e.toString())}');
    }

    notifyListeners();
  }

  void setSelectedSession(Data? session) {
    _selectedSession = session;
    notifyListeners();
  }

  void disposeSession() {
    fetchSessions();
    notifyListeners();
  }

  Data? getSelectedSession() {
    return _selectedSession;
  }
}
