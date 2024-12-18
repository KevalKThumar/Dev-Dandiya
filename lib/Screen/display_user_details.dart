// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dev_dandiya/Screen/home_screen.dart';
import 'package:dev_dandiya/model/get_student_model.dart' as syudentmodel;
import 'package:dev_dandiya/model/payment_list_model.dart' as paymentmodel;
import 'package:dev_dandiya/model/student_model.dart';
import 'package:dev_dandiya/provider/dropdown_provider.dart';
import 'package:dev_dandiya/provider/location_provider.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/provider/student_provider.dart';
import 'package:dev_dandiya/provider/user_details_provider.dart';
import 'package:dev_dandiya/widget/popup.dart';

import 'package:dev_dandiya/widget/text_form_field.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/user_details_simmer.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../const/color.dart';
import '../provider/payment_provider_display_user.dart';

class DisplayUserDetails extends StatefulWidget {
  final String studentId;
  const DisplayUserDetails({super.key, required this.studentId});

  @override
  State<DisplayUserDetails> createState() => _DisplayUserDetailsState();
}

class _DisplayUserDetailsState extends State<DisplayUserDetails> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final FocusNode userNameFocus = FocusNode();
  final TextEditingController mobileController = TextEditingController();
  final FocusNode mobileFocus = FocusNode();
  final TextEditingController codeController = TextEditingController();
  final FocusNode codeFocus = FocusNode();
  final FocusNode amountFocus = FocusNode();
  File? studentProfile;
  bool isUpdating = false;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    // Fetch payments when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paymentProvider =
          Provider.of<PaymentProvider>(context, listen: false);
      paymentProvider.fetchPayments(widget.studentId, context);

      amountController.text = paymentProvider.monthlyPayment.toString();
    });
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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDetailProvider>(context);
    final sessionProvider =
        Provider.of<SessionProvider>(context).getSelectedSession();
    String? currentYear = sessionProvider?.session ??
        Provider.of<SessionProvider>(context).sessions[1].session;
    final studentProvider = Provider.of<StudentProvider>(context);

    final locationId = Provider.of<LocationProvider>(context)
            .getSelectedLocation()
            ?.locationId ??
        '1';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: AppBar(
          
          iconTheme: const IconThemeData(
            color: AppColor.blackColor,
          ),
          leading: IconButton(
            onPressed: () {
              if (isUpdating) {
                setState(() {
                  isUpdating = !isUpdating;
                });
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          titleSpacing: 0,
          leadingWidth: 45,
          elevation: 0,
          title: Text(
            'Dev Dandiya',
            style: myTextStyle(
              color: AppColor.blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
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
          ],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: FutureBuilder(
                    future: userProvider.fetchStudentDetails(widget.studentId),
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      userNameController.text = data?.studentName ?? '';
                      mobileController.text = data?.studentMobile ?? '';
                      codeController.text = data?.studentCode ?? '';

                      if (snapshot.connectionState == ConnectionState.none) {
                        return Center(
                          child: Text(
                            'No internet connection',
                            style: myTextStyle(
                              color: AppColor.blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return buildShimmerLoading(context);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: myTextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else if (data == null) {
                        return Center(
                          child: Text(
                            'No data found',
                            style: myTextStyle(
                              color: AppColor.blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 70,
                                  bottom: 10,
                                ),
                                child: Container(
                                  width: 350,
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        isUpdating == false
                                            ? Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    height: 80,
                                                    width: 350,
                                                    decoration:
                                                        const BoxDecoration(
                                                      // liner gradient
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xffffa89e),
                                                          Color(0xffFCB4B0)
                                                        ],
                                                        stops: [0, 1],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(4),
                                                        topRight:
                                                            Radius.circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: -50,
                                                    left: 107,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              118, // Set the width and height to match the CircleAvatar's diameter
                                                          height: 118,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xffffa89e), // Background color matching CircleAvatar
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: data.studentGender ==
                                                                      'Male'
                                                                  ? const Color(
                                                                      0xffffa89e)
                                                                  : const Color(
                                                                      0xffFCB4B0,
                                                                    ), // Border color
                                                              width:
                                                                  4, // Border width
                                                            ),
                                                          ),
                                                          child: CircleAvatar(
                                                            radius:
                                                                60, // Radius of the circular image
                                                            foregroundImage:
                                                                NetworkImage(
                                                              data.studentProfile
                                                                  .toString(),
                                                            ),
                                                            backgroundColor: Colors
                                                                .transparent, // Set to transparent if you want only the image
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : studentProfile == null
                                                ? GestureDetector(
                                                    onTap: () {
                                                      _pickImage();
                                                    },
                                                    child: profilePicture(data),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      _pickImage();
                                                    },
                                                    child: Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          width: 350,
                                                          decoration:
                                                              const BoxDecoration(
                                                            // liner gradient
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xffffa89e),
                                                                Color(
                                                                    0xffFCB4B0)
                                                              ],
                                                              stops: [0, 1],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(4),
                                                              topRight: Radius
                                                                  .circular(4),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: -50,
                                                          left: 107,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    118, // Set the width and height to match the CircleAvatar's diameter
                                                                height: 118,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xffffa89e), // Background color matching CircleAvatar
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color: data.studentGender ==
                                                                            'Male'
                                                                        ? const Color(
                                                                            0xffffa89e)
                                                                        : const Color(
                                                                            0xffFCB4B0,
                                                                          ), // Border color
                                                                    width:
                                                                        4, // Border width
                                                                  ),
                                                                ),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius:
                                                                      60, // Radius of the circular image
                                                                  foregroundImage:
                                                                      FileImage(
                                                                          studentProfile!),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent, // Set to transparent if you want only the image
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        isUpdating == false
                                            ? SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 16,
                                                        right: 16,
                                                        left: 16,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Username',
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffa89e),
                                                              ),
                                                            ),
                                                            Text(
                                                              data.studentName
                                                                  .toString(),
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: AppColor
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 2,
                                                              color: Color(
                                                                  0xffffa89e),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Mobile',
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffa89e),
                                                              ),
                                                            ),
                                                            Text(
                                                              data.studentMobile
                                                                  .toString(),
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: AppColor
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 2,
                                                              color: Color(
                                                                  0xffffa89e),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Gender',
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffa89e),
                                                              ),
                                                            ),
                                                            Text(
                                                              data.studentGender
                                                                  .toString(),
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: AppColor
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                            const Divider(
                                                              thickness: 2,
                                                              color: Color(
                                                                  0xffffa89e),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16,
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Code',
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: const Color(
                                                                    0xffffa89e),
                                                              ),
                                                            ),
                                                            Text(
                                                              data.studentCode
                                                                  .toString(),
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: AppColor
                                                                    .blackColor,
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              thickness: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min, // Minimize the height of the column
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child: TextFormField(
                                                        style: myTextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .blackColor,
                                                        ),
                                                        controller:
                                                            userNameController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Username",
                                                          labelStyle:
                                                              myTextStyle(
                                                            color: const Color(
                                                                0xffffa89e),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                          ),
                                                          focusedBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          border:
                                                              const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        focusNode:
                                                            userNameFocus,
                                                        onFieldSubmitted:
                                                            (value) {
                                                          userNameFocus
                                                              .unfocus();
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                            mobileFocus,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child: TextFormField(
                                                        style: myTextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .blackColor,
                                                        ),
                                                        controller:
                                                            mobileController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Mobile Number",
                                                          labelStyle:
                                                              myTextStyle(
                                                            color: const Color(
                                                                0xffffa89e),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                          ),
                                                          focusedBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          border:
                                                              const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType.phone,
                                                        focusNode: mobileFocus,
                                                        onFieldSubmitted:
                                                            (value) {
                                                          mobileFocus.unfocus();
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                            codeFocus,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit
                                                          .loose, // Use loose fit to avoid expanding to fill the height
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                        child: Consumer<
                                                            DropdownProvider>(
                                                          builder: (context,
                                                              dropdownProvider,
                                                              _) {
                                                            return SizedBox(
                                                              height: 55,
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                isExpanded:
                                                                    true,
                                                                iconEnabledColor:
                                                                    const Color(
                                                                        0xffffa89e),
                                                                iconDisabledColor:
                                                                    const Color(
                                                                        0xffffa89e),
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      "Gender",
                                                                  labelStyle:
                                                                      myTextStyle(
                                                                    color: const Color(
                                                                        0xffffa89e),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        18,
                                                                  ),
                                                                  enabledBorder:
                                                                      const UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xffffa89e),
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                  border:
                                                                      const UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Color(
                                                                          0xffffa89e),
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                ),
                                                                value: data.studentGender ==
                                                                        "Male"
                                                                    ? "Male"
                                                                    : "Female",
                                                                onChanged: (String?
                                                                    newValue) {
                                                                  dropdownProvider
                                                                      .setGender(
                                                                          newValue!,
                                                                          context);
                                                                },
                                                                items: [
                                                                  'Male',
                                                                  'Female'
                                                                ].map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                      value,
                                                                      style:
                                                                          myTextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: AppColor
                                                                            .blackColor,
                                                                      ),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child: TextFormField(
                                                        style: myTextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .blackColor,
                                                        ),
                                                        readOnly:
                                                            true, // Set the TextField to be read-only
                                                        controller:
                                                            TextEditingController(
                                                          text: studentProvider
                                                              .code,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "Code",
                                                          labelStyle:
                                                              myTextStyle(
                                                            color: const Color(
                                                                0xffffa89e),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 18,
                                                          ),
                                                          focusedBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Color(
                                                                  0xffffa89e),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          border:
                                                              const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType.text,
                                                        focusNode: codeFocus,
                                                        onFieldSubmitted:
                                                            (value) {
                                                          codeFocus.unfocus();
                                                        },
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        Consumer2<StudentProvider,
                                            DropdownProvider>(
                                          builder: (context, studentProvider,
                                              dropdownProvider, child) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                right: 10.0,
                                                left: 10.0,
                                                bottom: 16,
                                                top: isUpdating ? 16 : 8,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: const Color(
                                                          0xffffa89e),
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    height: 40,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isUpdating =
                                                              !isUpdating;
                                                        });
                                                        if (isUpdating ==
                                                                false &&
                                                            (studentProfile !=
                                                                    null ||
                                                                data.studentProfile! !=
                                                                    '')) {
                                                          final student =
                                                              Student(
                                                                "",
                                                            studentName:
                                                                userNameController
                                                                    .text,
                                                            studentMobile:
                                                                mobileController
                                                                    .text,
                                                            studentGender:
                                                                dropdownProvider
                                                                    .selectedGender,
                                                            studentCode:
                                                                codeController
                                                                    .text,
                                                            studentSession:
                                                                currentYear!, // Replace with dynamic session if needed
                                                            studentLocation:
                                                                locationId, // Replace with dynamic location if needed
                                                            studentProfile:
                                                                studentProfile
                                                                        ?.path ??
                                                                    data.studentProfile!,
                                                          );
                                                          studentProvider
                                                              .updateStudent(
                                                            widget.studentId,
                                                            student,
                                                            context,
                                                          );
                                                          setState(() {
                                                            isUpdating = false;
                                                          });
                                                          showSnackBar(
                                                            context,
                                                            'Profile Updated',
                                                            const Color(
                                                                0xffffa89e),
                                                          );
                                                        }
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          isUpdating
                                                              ? 'Submit'
                                                              : 'Update',
                                                          style: myTextStyle(
                                                            fontSize: 16,
                                                            color: AppColor
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Colors.grey,
                                                    ),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    height: 40,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showDeletionPopup(
                                                          context,
                                                          'Student Profile',
                                                          () {
                                                            studentProvider
                                                                .deleteStudent(
                                                                    widget
                                                                        .studentId,
                                                                    context);

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const HomeScreen(),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          'Delete',
                                                          style: myTextStyle(
                                                            fontSize: 16,
                                                            color: AppColor
                                                                .whiteColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              isUpdating
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Consumer<PaymentProvider>(
                        builder: (context, paymentProvider, child) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6.0),
                              child: SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 16),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        'Payment Status',
                                        style: myTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffffa89e),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile<PaymentStatus>(
                                            contentPadding: EdgeInsets.zero,
                                            activeColor:
                                                const Color(0xffffa89e),
                                            title: Text(
                                              'New',
                                              style: myTextStyle(
                                                color: AppColor.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            value: PaymentStatus.New,
                                            groupValue:
                                                paymentProvider.paymentStatus,
                                            onChanged: (value) {
                                              paymentProvider
                                                  .setPaymentStatus(value!);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile<PaymentStatus>(
                                            contentPadding: EdgeInsets.zero,
                                            activeColor:
                                                const Color(0xffffa89e),
                                            title: Text(
                                              'Renew',
                                              style: myTextStyle(
                                                color: AppColor.blackColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            value: PaymentStatus.Renew,
                                            groupValue:
                                                paymentProvider.paymentStatus,
                                            onChanged: (value) {
                                              paymentProvider
                                                  .setPaymentStatus(value!);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        'Payment Type',
                                        style: myTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffffa89e),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile<PaymentType>(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              'Month',
                                              style: myTextStyle(
                                                color: AppColor.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            activeColor:
                                                const Color(0xffffa89e),
                                            value: PaymentType.Monhlty,
                                            groupValue:
                                                paymentProvider.paymentType,
                                            onChanged: (value) {
                                              paymentProvider
                                                  .setPaymentType(value!);
                                              amountController.text =
                                                  paymentProvider.monthlyPayment
                                                      .toString();
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile<PaymentType>(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              'Year',
                                              style: myTextStyle(
                                                color: AppColor.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            value: PaymentType.Yearly,
                                            activeColor:
                                                const Color(0xffffa89e),
                                            groupValue:
                                                paymentProvider.paymentType,
                                            onChanged: (value) {
                                              paymentProvider
                                                  .setPaymentType(value!);
                                              amountController.text =
                                                  paymentProvider.yearlyPayment
                                                      .toString();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        'Payment Method',
                                        style: myTextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffffa89e),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RadioListTile<PaymentMethod>(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              'Cash',
                                              style: myTextStyle(
                                                color: AppColor.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            value: PaymentMethod.Cash,
                                            activeColor:
                                                const Color(0xffffa89e),
                                            groupValue:
                                                paymentProvider.paymentMethod,
                                            onChanged: (value) {
                                              paymentProvider
                                                  .setPaymentMethod(value!);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: RadioListTile<PaymentMethod>(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              'Online',
                                              style: myTextStyle(
                                                color: AppColor.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            value: PaymentMethod.Online,
                                            activeColor:
                                                const Color(0xffffa89e),
                                            groupValue:
                                                paymentProvider.paymentMethod,
                                            onChanged: (value) {
                                              paymentProvider
                                                  .setPaymentMethod(value!);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                        'Amount',
                                        style: myTextStyle(
                                          color: const Color(0xffffa89e),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: AuthField(
                                        hintText: 'Payment Amount',
                                        controller: amountController,
                                        prefixIcon: const Icon(
                                          Icons.currency_rupee_outlined,
                                          color: Color(0xffffa89e),
                                        ),
                                        focusNode: amountFocus,
                                        textInputType: TextInputType.number,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    paymentProvider.isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: const Color(0xffffa89e),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              height: 40,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (amountController
                                                      .text.isNotEmpty) {
                                                    paymentProvider
                                                        .insertPayment(
                                                      context: context,
                                                      studentId:
                                                          widget.studentId,
                                                      locationId: locationId,
                                                      studentSession:
                                                          currentYear!,
                                                      studentType: paymentProvider
                                                                  .paymentStatus ==
                                                              PaymentStatus.New
                                                          ? "New"
                                                          : "Renew",
                                                      paymentType: paymentProvider
                                                                  .paymentType ==
                                                              PaymentType
                                                                  .Monhlty
                                                          ? "Monhlty"
                                                          : "Yearly",
                                                      paymentMethod: paymentProvider
                                                                  .paymentMethod ==
                                                              PaymentMethod.Cash
                                                          ? "Cash"
                                                          : "Online",
                                                      paymentAmount:
                                                          amountController.text,
                                                      paymentDate:
                                                          DateTime.now()
                                                              .toString()
                                                              .substring(0, 10),
                                                    );
                                                  }

                                                  amountController.text =
                                                      paymentProvider
                                                          .monthlyPayment;
                                                  paymentProvider
                                                      .setPaymentMethod(
                                                          PaymentMethod.Cash);
                                                  paymentProvider
                                                      .setPaymentType(
                                                          PaymentType.Monhlty);
                                                  paymentProvider
                                                      .setPaymentStatus(
                                                          PaymentStatus.New);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Submit Payment',
                                                    style: myTextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              isUpdating
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder(
                        future: context.read<PaymentProvider>().fetchPayments(
                              widget.studentId,
                              context,
                            ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          } else if (snapshot.hasError) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: myTextStyle(
                                    color: AppColor.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'No payments found',
                                  style: myTextStyle(
                                    color: AppColor.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final payments =
                                snapshot.data as List<paymentmodel.Data>;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: payments.length,
                              itemBuilder: (context, index) {
                                final payment = payments[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8, bottom: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Payment ID: ',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffa89e),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Student Type: ',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffa89e),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Payment Amount: ',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffa89e),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Date: ',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffa89e),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Payment Type: ',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffa89e),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Payment Method: ',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffffa89e),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text:
                                                    payment.studentPaymentId ??
                                                        'N/A',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: payment.studentType ??
                                                    'N/A',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: payment.paymentAmount ??
                                                    'N/A',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: payment.paymentDate ??
                                                    'N/A',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: payment.paymentType ??
                                                    'N/A',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: payment.paymentMethod ??
                                                    'N/A',
                                                style: myTextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDeletionPopup(
                                            context,
                                            "Payment",
                                            () {
                                              context
                                                  .read<PaymentProvider>()
                                                  .deletePaynment(
                                                      payment.studentPaymentId!,
                                                      context);
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: Color(0xffffa89e),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Stack profilePicture(syudentmodel.Data data) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          width: 350,
          decoration: const BoxDecoration(
            // liner gradient
            gradient: LinearGradient(
              colors: [Color(0xffffa89e), Color(0xffFCB4B0)],
              stops: [0, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ),
        Positioned(
          top: -50,
          left: 107,
          child: Column(
            children: [
              Container(
                width:
                    118, // Set the width and height to match the CircleAvatar's diameter
                height: 118,
                decoration: BoxDecoration(
                  color: const Color(
                      0xffffa89e), // Background color matching CircleAvatar
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: data.studentGender == 'Male'
                        ? const Color(0xffffa89e)
                        : const Color(
                            0xffFCB4B0,
                          ), // Border color
                    width: 4, // Border width
                  ),
                ),
                child: CircleAvatar(
                  radius: 60, // Radius of the circular image
                  foregroundImage: NetworkImage(
                    data.studentProfile.toString(),
                  ),
                  backgroundColor: Colors
                      .transparent, // Set to transparent if you want only the image
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
