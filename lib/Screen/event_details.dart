// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dev_dandiya/Screen/event_screen.dart';
import 'package:dev_dandiya/Screen/search_screen.dart';
import 'package:dev_dandiya/provider/event_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../const/color.dart';
import '../provider/session_provider.dart';
import '../widget/text_style.dart';
import '../widget/session_selection_dialog.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  File? eventPicture;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    eventPicture = null;
    super.dispose();
  }

  Future<void> _pickImage() async {
    final cameraPermission = await Permission.camera.request();
    final galleryPermission = await Permission.photos.request();
    if (cameraPermission.isGranted || galleryPermission.isGranted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        eventPicture = File(pickedFile.path);
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        eventPicture = File(pickedFile.path);
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissions are required to pick an image.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider =
        Provider.of<SessionProvider>(context).getSelectedSession();
    String? currentYear = sessionProvider?.session ??
        Provider.of<SessionProvider>(context).sessions[1].session;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.whiteColor,
        ),
        titleSpacing: 0,
        leadingWidth: 45,
        elevation: 0,
        title: Text(
          'Dev Dandiya',
          style: myTextStyle(
            color: AppColor.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xff5F259E),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SessionSelectionDialog();
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                '$currentYear',
                style: myTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.search,
              color: AppColor.whiteColor,
              size: 28.0,
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      eventPicture == null
                          ? GestureDetector(
                              onTap: () {
                                _pickImage();
                              },
                              child: DottedBorder(
                                strokeWidth: 2,
                                color: const Color(0xff5F259E),
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(4),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder_open,
                                        size: 50,
                                        color: Color(0xff5F259E),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Select your image',
                                        style: myTextStyle(
                                          fontSize: 17,
                                          color: const Color(0xff5F259E),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _pickImage();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.file(
                                  eventPicture!,
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(
                              16), // Adjust padding for better readability
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide
                                .none, // Add a slight border for better visibility
                            borderRadius:
                                BorderRadius.circular(4), // Rounded border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide
                                .none, // Highlight border when focused
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintStyle: myTextStyle(
                            color: const Color(0xff5F259E).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          hintText: 'Enter your description here...',
                          filled: true,
                          fillColor: const Color(0xff5F259E).withOpacity(
                              0.05), // Slight background tint for text area
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines:
                            null, // Allows for an indefinite number of lines
                        scrollPhysics:
                            const BouncingScrollPhysics(), // More natural scrolling behavior for multiline input
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      Consumer<EventProvider>(
                        builder: (context, eventProvider, child) {
                          return eventProvider.isLoadingInsert == true
                              ? const CircularProgressIndicator(
                                  color: Color(0xff5F259E),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            eventProvider.insertEvent(
                                              descriptionController.text,
                                              eventPicture,
                                              context,
                                            );
                                          }
                                          setState(() {
                                            eventPicture = null;
                                          });
                                          descriptionController.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff5F259E),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            )),
                                        child: Text(
                                          'Submit',
                                          style: myTextStyle(
                                            color: AppColor.whiteColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.44,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            eventPicture = null;
                                          });
                                          descriptionController.clear();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            )),
                                        child: Text(
                                          'Clear',
                                          style: myTextStyle(
                                            color: AppColor.whiteColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                      // event List view
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  return eventProvider.isLoading == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Shimmer.fromColors(
                            baseColor:
                                Colors.grey[300]!, // Base color for the shimmer
                            highlightColor: Colors
                                .grey[100]!, // Highlight color for the shimmer
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColor.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.blackColor.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0),
                                    child: Container(
                                      height: 150,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey[
                                            300], // Placeholder color for shimmer effect
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Container(
                                    height: 20,
                                    width: 200,
                                    color: Colors.grey[
                                        300], // Placeholder color for shimmer effect
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : eventProvider.events.isEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: const Text('No events found'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: eventProvider.events.length,
                              itemBuilder: (context, index) {
                                return eventCard(
                                  description: eventProvider
                                      .events[index].eventDescription!,
                                  image:
                                      eventProvider.events[index].eventImage!,
                                  eventId: eventProvider.events[index].eventId!,
                                );
                              },
                            );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget eventCard({
    required String description,
    required String image,
    required String eventId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(
              eventId: eventId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding:
              const EdgeInsets.only(top: 10.0, bottom: 7, left: 10, right: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColor.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: NetworkImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description,
                  style: myTextStyle(
                    color: AppColor.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
