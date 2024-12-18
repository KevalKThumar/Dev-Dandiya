// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dev_dandiya/Screen/search_screen.dart';
import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/model/student_model.dart';
import 'package:dev_dandiya/provider/dropdown_provider.dart';
import 'package:dev_dandiya/provider/location_provider.dart';
import 'package:dev_dandiya/provider/payment_provider_add_user.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/svg_url.dart';
import 'package:dev_dandiya/widget/text_form_field.dart';
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

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode mobileNumberFocusNode = FocusNode();
  final FocusNode codeFocusNode = FocusNode();
  final FocusNode monthFocusNode = FocusNode();
  final FocusNode dateFoucsNode = FocusNode();
  String selectedGender = 'Male';

  @override
  void initState() {
    context.read<StudentProvider>().getCode(
          context,
          studentGender: selectedGender,
        );
    super.initState();
  }

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
        dateController.text,
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
    final paymentMethodProvider = Provider.of<PaymentMethodProvider>(context);
    final paymentTypeProvider = Provider.of<PaymentTypeProvider>(context);
    final genderProvider = Provider.of<GenderProvider>(context);
    final sessionProvider =
        Provider.of<SessionProvider>(context).getSelectedSession();
    String? currentYear = sessionProvider?.session ??
        Provider.of<SessionProvider>(context).sessions[1].session;
    final locationId =
        context.watch<LocationProvider>().getSelectedLocation()?.locationId;
    codeController.text = context.watch<StudentProvider>().code;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColor.blackColor,
        ),
        titleSpacing: 0,
        leadingWidth: 45,
        elevation: 0,
        title: Image.asset(
          'assets/devlogo.png',
          width: 120,
        ),
        backgroundColor: AppColor.whiteColor,
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
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.blackColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(6)),
              padding: const EdgeInsets.all(4.0),
              child: Text(
                currentYear!,
                style: myTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.blackColor,
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
              color: AppColor.blackColor,
              size: 28.0,
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Center(
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
            const SizedBox(
              height: 20,
            ),
            // name authfield
            AuthField(
              hintText: "Name",
              controller: usernameController,
              focusNode: usernameFocusNode,
              textInputType: TextInputType.text,
              nextFocus: mobileNumberFocusNode,
            ),
            const SizedBox(
              height: 4,
            ),
            // row
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: AuthField(
                    hintText: 'Mobile No.',
                    controller: mobileNumberController,
                    focusNode: mobileNumberFocusNode,
                    textInputType: TextInputType.phone,
                    nextFocus: monthFocusNode,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<Gender>(
                        activeColor: const Color(0xffffa89e),
                        value: Gender.male,
                        groupValue: genderProvider.selectedGender,
                        onChanged: (Gender? value) {
                          if (value != null) {
                            genderProvider.setGender(value);
                            selectedGender = "Male";
                            context.read<StudentProvider>().getCode(
                                  context,
                                  studentGender: selectedGender,
                                );
                          }
                        },
                      ),
                      const Icon(Icons.boy, color: Color(0xffffa89e)),
                      Radio<Gender>(
                        activeColor: const Color(0xffffa89e),
                        value: Gender.female,
                        groupValue: genderProvider.selectedGender,
                        onChanged: (Gender? value) {
                          if (value != null) {
                            genderProvider.setGender(value);
                            selectedGender = "Female";
                            context.read<StudentProvider>().getCode(
                                  context,
                                  studentGender: selectedGender,
                                );
                          }
                        },
                      ),
                      const Icon(
                        Icons.girl,
                        color: Color(0xffffa89e),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: AuthField(
                    hintText: '0',
                    controller: monthController,
                    focusNode: monthFocusNode,
                    textInputType: TextInputType.number,
                    nextFocus: codeFocusNode,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<PaymentType>(
                        activeColor: const Color(0xffffa89e),
                        value: PaymentType.monthly,
                        groupValue: paymentTypeProvider.selectedPaymentType,
                        onChanged: (PaymentType? value) {
                          if (value != null) {
                            paymentTypeProvider.setPaymentType(value);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Y",
                          style: myTextStyle(
                            color: const Color(0xffffa89e),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 10),
                      Radio<PaymentType>(
                        activeColor: const Color(0xffffa89e),
                        value: PaymentType.yearly,
                        groupValue: paymentTypeProvider.selectedPaymentType,
                        onChanged: (PaymentType? value) {
                          if (value != null) {
                            paymentTypeProvider.setPaymentType(value);
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "M",
                          style: myTextStyle(
                            color: const Color(0xffffa89e),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<PaymentMethod>(
                        activeColor: const Color(0xffffa89e),
                        value: PaymentMethod.cash,
                        groupValue: paymentMethodProvider.selectedPaymentMethod,
                        onChanged: (PaymentMethod? value) {
                          if (value != null) {
                            paymentMethodProvider.setPaymentMethod(value);
                          }
                        },
                      ),
                      const SvgImage(
                        url: "assets/svg/caseNote.svg",
                        height: 25,
                      ),
                      const SizedBox(width: 10),
                      Radio<PaymentMethod>(
                        activeColor: const Color(0xffffa89e),
                        value: PaymentMethod.online,
                        groupValue: paymentMethodProvider.selectedPaymentMethod,
                        onChanged: (PaymentMethod? value) {
                          if (value != null) {
                            paymentMethodProvider.setPaymentMethod(value);
                          }
                        },
                      ),
                      const SvgImage(
                          url: "assets/svg/online-pay.svg", height: 20),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 4,
                  child: AuthField(
                    hintText: 'E69',
                    controller: codeController,
                    focusNode: codeFocusNode,
                    textInputType: TextInputType.number,
                    nextFocus: dateFoucsNode,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AuthField(
              hintText: "Sat Aug 31 2024",
              controller: dateController,
              focusNode: dateFoucsNode,
              textInputType: TextInputType.text,
            ),

            const SizedBox(height: 20),
            context.watch<StudentProvider>().isLoading
                ? const Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        color: Color(0xffffa89e),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitForm(currentYear, locationId!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffffa89e),
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
                        width: MediaQuery.of(context).size.width * 0.45,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
