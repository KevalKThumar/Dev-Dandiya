import 'dart:convert';
import 'package:dev_dandiya/const/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/location_model.dart';

class LocationProvider with ChangeNotifier {
  List<Location> _locations = [];
  Location? _selectedLocation;
  bool _isLoading = false;

  List<Location> get locations => _locations;
  Location? get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;

  Future<void> fetchLocations() async {
    _isLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('${BaseUrl.url}/location'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        _locations = (data['data'] as List).map((locationJson) {
          return Location.fromJson(locationJson);
        }).toList();
        // Safely assign the selected location
        _selectedLocation = _locations.isNotEmpty ? _locations[0] : null;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedLocation(Location? location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void disposeLocation() {
    fetchLocations();
    notifyListeners();
  }

  Location? getSelectedLocation() {
    return _selectedLocation;
  }
}
