// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/provider/event_provider.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../widget/popup.dart';

class EventScreen extends StatefulWidget {
  final String eventId;
  const EventScreen({super.key, required this.eventId});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  TextEditingController descriptionController = TextEditingController();
  File? eventPicture;
  final ImagePicker _picker = ImagePicker();
  bool isUpdate = false;

  @override
  void dispose() {
    descriptionController.dispose();
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

    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: false,
      floatingActionButton: isUpdate
          ? FloatingActionButton(
              heroTag: 'delete',
              tooltip: "Delete Event",
              onPressed: () {
                showDeletionPopup(
                  context,
                  'Event',
                  () {
                    eventProvider.deleteEvent(widget.eventId, context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Event Deleted',
                          style: myTextStyle(
                            color: AppColor.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: const Color(0xff5F259E),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(10),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              },
              backgroundColor: const Color(0xff5F259E),
              child: const Icon(
                Icons.delete_rounded,
                color: AppColor.whiteColor,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'edit',
                  tooltip: "Edit Event",
                  onPressed: () {
                    setState(() {
                      isUpdate = true;
                    });
                  },
                  backgroundColor: const Color(0xff5F259E),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: AppColor.whiteColor,
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  heroTag: 'delete',
                  tooltip: "Delete Event",
                  onPressed: () {
                    showDeletionPopup(
                      context,
                      'Event',
                      () {
                        eventProvider.deleteEvent(widget.eventId, context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Event Deleted',
                              style: myTextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: const Color(0xff5F259E),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(10),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  backgroundColor: const Color(0xff5F259E),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: AppColor.whiteColor,
                  ),
                ),
              ],
            ),
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.whiteColor,
        ),
        leading: IconButton(
          onPressed: () {
            if (isUpdate) {
              setState(() {
                isUpdate = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back_sharp),
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
        ],
      ),
      body: FutureBuilder(
        future: eventProvider.fetchEventDetails(widget.eventId, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else {
            final event = snapshot.data;
            descriptionController.text = event?.eventDescription ?? '';
            return Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 7, left: 10, right: 10),
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
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isUpdate
                          ? eventPicture == null
                              ? GestureDetector(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            event?.eventImage ?? ''),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: FileImage(eventPicture!),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                image: DecorationImage(
                                  image: NetworkImage(event?.eventImage ?? ''),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                      const SizedBox(height: 12),
                      Text(
                        isUpdate
                            ? "Update Event Description"
                            : "Event Description :-",
                        style: myTextStyle(
                          color: AppColor.blackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      isUpdate
                          ? TextFormField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(
                                    16), // Adjust padding for better readability
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  // Add a slight border for better visibility
                                  borderRadius: BorderRadius.circular(
                                      4), // Rounded border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide
                                      .none, // Highlight border when focused
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                hintStyle: myTextStyle(
                                  color:
                                      const Color(0xff5F259E).withOpacity(0.7),
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
                            )
                          : Text(
                              event!.eventDescription ?? '',
                              style: myTextStyle(
                                color: AppColor.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      const SizedBox(height: 10),
                      isUpdate
                          ? Consumer<EventProvider>(
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (descriptionController
                                                        .text.isNotEmpty &&
                                                    (eventPicture != null ||
                                                        event!.eventImage !=
                                                            null)) {
                                                  if (eventPicture != null) {
                                                    eventProvider.updateEvent(
                                                      widget.eventId,
                                                      context,
                                                      eventDescription:
                                                          descriptionController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? descriptionController
                                                                  .text
                                                              : event!
                                                                  .eventDescription,
                                                      eventImageFile:
                                                          eventPicture,
                                                    );
                                                  } else {
                                                    eventProvider.updateEvent(
                                                      widget.eventId,
                                                      context,
                                                      eventDescription:
                                                          descriptionController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? descriptionController
                                                                  .text
                                                              : event!
                                                                  .eventDescription,
                                                      eventImageUrl:
                                                          event!.eventImage,
                                                    );
                                                  }
                                                  setState(() {
                                                    eventPicture = null;
                                                  });
                                                  descriptionController.clear();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Event updated successfully',
                                                        style: myTextStyle(
                                                          color: AppColor
                                                              .whiteColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          const Color(
                                                              0xff5F259E),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      margin:
                                                          const EdgeInsets.all(
                                                              10),
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ),
                                                  );
                                                  Navigator.pop(context);
                                                } else {
                                                  showSnackBar(
                                                    context,
                                                    'Please select an image or enter a description',
                                                    Colors.red,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff5F259E),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  )),
                                              child: Text(
                                                'update',
                                                style: myTextStyle(
                                                  color: AppColor.whiteColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.43,
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
                                                        BorderRadius.circular(
                                                            4),
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
                            )
                          : Container(),
                      // const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
