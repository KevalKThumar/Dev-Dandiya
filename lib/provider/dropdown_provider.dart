// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class DropdownProvider with ChangeNotifier {
  String _selectedGender = 'Gender';
  String _selectedYear = 'Year';

  String get selectedGender => _selectedGender;
  String get selectedYear => _selectedYear;

  void setGender(String gender, BuildContext context) {
    _selectedGender = gender;
    notifyListeners();
  }

  void setYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }
}
