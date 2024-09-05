// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dev_dandiya/Screen/search_screen.dart';
import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/model/student_model.dart';
import 'package:dev_dandiya/provider/dropdown_provider.dart';
import 'package:dev_dandiya/provider/location_provider.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/student_provider.dart';

class AddUserDetails extends StatefulWidget {
  const AddUserDetails({super.key});

  @override
  State<AddUserDetails> createState() => _AddUserDetailsState();
}

class _AddUserDetailsState extends State<AddUserDetails> {
  File? studentProfile;
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode mobileNumberFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();

  String selectedGender = 'Male';

  @override
  void dispose() {
    usernameController.dispose();
    mobileNumberController.dispose();
    codeController.dispose();
    usernameFocusNode.dispose();
    mobileNumberFocusNode.dispose();
    codeFocusNode.dispose();
    studentProfile = null;
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
                        studentProfile = File(pickedFile.path);
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
                        studentProfile = File(pickedFile.path);
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

  Future<void> _submitForm(
      String studentSession, String studentLocation) async {
    if (usernameController.text.isNotEmpty &&
        mobileNumberController.text.isNotEmpty) {
      final student = Student(
        studentName: usernameController.text,
        studentMobile: mobileNumberController.text,
        studentGender: selectedGender,
        studentCode: codeController.text,
        studentSession:
            studentSession, // Replace with dynamic session if needed
        studentLocation:
            studentLocation, // Replace with dynamic location if needed
        studentProfile: studentProfile?.path ?? '',
      );

      await context.read<StudentProvider>().insertStudent(student, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
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
    final locationId =
        context.watch<LocationProvider>().getSelectedLocation()?.locationId;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
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
                currentYear!, // Replace with dynamic session year
                style: myTextStyle(
                  fontSize: 18,
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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 74, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 80,
                          width: 350,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff5F259E), Color(0xfff5afff)],
                              stops: [0, 1],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -50,
                          left: 107,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 118,
                              height: 118,
                              decoration: BoxDecoration(
                                color: const Color(0xff5F259E),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xfff5afff),
                                  width: 4,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                foregroundImage: studentProfile != null
                                    ? FileImage(studentProfile!)
                                    : const NetworkImage(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        style: myTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff5F259E),
                        ),
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: myTextStyle(
                            color: const Color(0xff5F259E),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff5F259E),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff5F259E),
                              width: 2,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: usernameFocusNode,
                        onFieldSubmitted: (value) {
                          usernameFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(mobileNumberFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        style: myTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff5F259E),
                        ),
                        controller: mobileNumberController,
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          labelStyle: myTextStyle(
                            color: const Color(0xff5F259E),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff5F259E),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff5F259E),
                              width: 2,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        focusNode: mobileNumberFocusNode,
                        onFieldSubmitted: (value) {
                          mobileNumberFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(codeFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Consumer<DropdownProvider>(
                        builder: (context, dropdownProvider, _) {
                          return SizedBox(
                            height: 55,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              iconEnabledColor: const Color(0xff5f259e),
                              iconDisabledColor: const Color(0xff5f259e),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                labelStyle: myTextStyle(
                                  color: const Color(0xff5F259E),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff5F259E),
                                    width: 2,
                                  ),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff5F259E),
                                    width: 2,
                                  ),
                                ),
                              ),
                              value: "Male",
                              onChanged: (String? newValue) {
                                context.read<StudentProvider>().getCode(
                                      context,
                                      studentGender: newValue!,
                                    );
                                dropdownProvider.setGender(newValue, context);
                              },
                              items: [
                                'Male',
                                'Female'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: myTextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff5F259E),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                    Consumer<StudentProvider>(
                      builder: (context, studentProvider, _) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: TextFormField(
                            style: myTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff5F259E),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentProvider.code),
                            decoration: InputDecoration(
                              labelText: "Code",
                              labelStyle: myTextStyle(
                                color: const Color(0xff5F259E),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5F259E),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff5F259E),
                                  width: 2,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            focusNode: codeFocusNode,
                            onFieldSubmitted: (value) {
                              codeFocusNode.unfocus();
                            },
                            textInputAction: TextInputAction.done,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: context.watch<StudentProvider>().isLoading
                          ? const Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(
                                  color: Color(0xff5F259E),
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _submitForm(currentYear, locationId!);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff5F259E),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Text('Submit',
                                        style: myTextStyle(
                                          color: AppColor.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Clear All Fields
                                      usernameController.clear();
                                      mobileNumberController.clear();
                                      studentProfile = null;
                                      setState(() {
                                        selectedGender = 'Male';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      'Clear',
                                      style: myTextStyle(
                                        color: AppColor.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
