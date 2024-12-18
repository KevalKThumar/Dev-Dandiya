// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../model/event_model.dart';

class EventProvider with ChangeNotifier {
  List<Data> _events = []; // Private variable to store events

  List<Data> get events => _events; // Getter for the events

  final Data _eventDetails = Data();

  Data get eventDetails => _eventDetails;

  bool _isLoading = false;
  bool _isLoadingInsert = false;

  bool get isLoading => _isLoading;

  bool get isLoadingInsert => _isLoadingInsert;

  EventProvider(BuildContext context) {
    fetchEvents(context); // Fetch events when the provider is initialized);
  }

  // Fetch all events


  // Fetch event details
  Future<Data> fetchEventDetails(String eventId, BuildContext context) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('http://gujele.in/devdandiya/api/event_details'));
      request.fields['event_id'] = eventId;

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);

        if (jsonResponse['status'] == 'success') {
          return Data.fromJson(jsonResponse['data']);
        } else if (jsonResponse['status'] == 'fail') {
          throw Exception('Failed to load event details');
        }
      } else {
        throw Exception('Failed to load event details');
      }
    } catch (e) {
      rethrow;
    }
    return Data();
  }

  // Insert a new event with an image file
  Future<void> fetchEvents(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      events.clear();

      final response = await http
          .post(Uri.parse('http://gujele.in/devdandiya/api/list_events'));

      if (response.statusCode == 200) {
        final eventModel = EventModel.fromJson(json.decode(response.body));

        if (eventModel.status == 'success') {
          _events = (eventModel.eventData ?? []).reversed.toList();
        } else {
          showSnackBar(context, eventModel.message ?? 'Failed to fetch events',
              Colors.red);
        }
      } else {
        showSnackBar(
            context,
            'Failed to load events. Server Error: ${response.statusCode}',
            Colors.red);
      }
    } catch (e) {
      showSnackBar(
          context, 'An error occurred while fetching events: $e', Colors.red);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertEvent(
      String eventDescription, File? eventImage, BuildContext context) async {
    try {
      _isLoadingInsert = true;
      notifyListeners();

      // Send the image file to the server

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://gujele.in/devdandiya/api/insert_event'));
      request.fields['event_description'] = eventDescription;

      if (eventImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('event_image', eventImage.path));
      }

      final response = await request.send();

      final responseData = await response.stream.bytesToString();
      final eventModel = EventModel.fromJson(json.decode(responseData)['data']);

      if (json.decode(responseData)['status'] == 'success') {
        showSnackBar(
            context,
            eventModel.message ?? 'Event inserted successfully',
            const Color(0xffffa89e));
        await fetchEvents(context);
      } else {
        showSnackBar(context, eventModel.message ?? 'Failed to insert event',
            Colors.red);
      }
    } catch (e) {
      showSnackBar(
          context, 'An error occurred while inserting event: $e', Colors.red);
    } finally {
      _isLoadingInsert = false;
      notifyListeners();
    }
  }

  // Update an existing event with an image file
  Future<void> updateEvent(String eventId, BuildContext context,
      {String? eventDescription,
      String? eventImageUrl,
      File? eventImageFile}) async {
    _isLoading = true;
    notifyListeners();

    // Initialize Multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://gujele.in/devdandiya/api/update_event'),
    );
    request.fields['event_id'] = eventId;

    // Add description if provided
    if (eventDescription != null) {
      request.fields['event_description'] = eventDescription;
    }

    // Handle event image from URL or File
    if (eventImageFile != null) {
      // If a File is directly provided
      request.files.add(
        await http.MultipartFile.fromPath('event_image', eventImageFile.path),
      );
    } else if (eventImageUrl != null) {
      // If only a String URL is provided
      File? imageFile;
      if (eventImageUrl.startsWith('http')) {
        // If the URL is a network URL, download the file
        imageFile = await _downloadFile(eventImageUrl);
      } else {
        // If it's a local file path, create a File object
        imageFile = File(eventImageUrl);
      }

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('event_image', imageFile.path),
        );
      }
    }

    // Send the request
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (jsonData['status'] == 'success') {
        await fetchEvents(context); // Refresh the list after update
      } else if (jsonData['status'] == 'fail') {
        showSnackBar(context, jsonData['message'] ?? 'Failed to update event',
            Colors.red);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to update event');
      }
    } else {
      throw Exception('Failed to update event');
    }

    _isLoading = false;
    notifyListeners();
  }

// Helper function to download and convert network image to File
  Future<File?> _downloadFile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Get the temporary directory of the device
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/${url.split('/').last}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
    }
    return null;
  }

  // Delete an event
  Future<void> deleteEvent(String eventId, BuildContext context) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://gujele.in/devdandiya/api/delete_event'));
    request.fields['event_id'] = eventId;

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      if (jsonData['status'] == 'success') {
        await fetchEvents(context); // Refresh the list after deletion
      } else if (jsonData['status'] == 'fail') {
        showSnackBar(context, jsonData['message'] ?? 'Failed to delete event',
            Colors.red);
      } else {
        throw Exception(jsonData['message'] ?? 'Failed to delete event');
      }
    } else {
      throw Exception('Failed to delete event');
    }
  }
}
