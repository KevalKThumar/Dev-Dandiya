// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dev_dandiya/Screen/display_user_details.dart';
import 'package:dev_dandiya/model/message_model.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/provider/student_provider.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/svg_url.dart';
import 'package:dev_dandiya/widget/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../provider/dropdown_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final FocusNode codeFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode mobileNumberFocusNode = FocusNode();

  @override
  void dispose() {
    usernameController.dispose();
    mobileNumberController.dispose();
    usernameFocusNode.dispose();
    mobileNumberFocusNode.dispose();
    codeController.dispose();
    codeFocusNode.dispose();
    super.dispose();
  }

  void sendMessageToWhatsApp(
      String message, BuildContext context, String phoneNumber) async {
    final String encodedMessage =
        Uri.encodeComponent(message); // Encode the message

    final Uri whatsappUrl =
        Uri.parse('https://wa.me/+91$phoneNumber?text=$encodedMessage');

    // Check if the URL can be launched
    if (await canLaunchUrl(whatsappUrl)) {
      // Launch the URL
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
        ),
      );
    }
  }

  late Message message;

  @override
  void initState() {
    setMessage();
    super.initState();
  }

  void setMessage() async {
    final response =
        await http.get(Uri.parse('http://gujele.in/devdandiya/api/message'));

    if (response.statusCode == 200) {
      message = Message.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load messages');
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
        backgroundColor: const Color(0xffffa89e),
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
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            children: [
              Container(
                width: 350,
                padding: const EdgeInsets.only(
                    top: 12, bottom: 12, left: 11, right: 11),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthField(
                      hintText: "Username",
                      controller: usernameController,
                      focusNode: usernameFocusNode,
                      textInputType: TextInputType.name,
                      nextFocus: mobileNumberFocusNode,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Expanded(
                          child: Consumer<DropdownProvider>(
                            builder: (context, dropdownProvider, _) {
                              return SizedBox(
                                height: 40,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  iconEnabledColor: const Color(0xffffa89e),
                                  iconDisabledColor: const Color(0xffffa89e),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffa89e)
                                        .withOpacity(0.1),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  value: dropdownProvider.selectedGender,
                                  onChanged: (String? newValue) {
                                    dropdownProvider.setGender(
                                        newValue!, context);
                                  },
                                  items: ['Male', 'Female', 'Gender']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: myTextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xffffa89e),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Consumer<DropdownProvider>(
                            builder: (context, dropdownProvider, _) {
                              return SizedBox(
                                height: 40,
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  iconEnabledColor: const Color(0xffffa89e),
                                  iconDisabledColor: const Color(0xffffa89e),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffffa89e)
                                        .withOpacity(0.1),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  value: dropdownProvider.selectedYear,
                                  onChanged: (String? newValue) {
                                    dropdownProvider.setYear(newValue!);
                                  },
                                  items: ['2023', '2024', '2025', "Year"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: myTextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xffffa89e),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: AuthField(
                            hintText: "Number",
                            controller: mobileNumberController,
                            focusNode: mobileNumberFocusNode,
                            textInputType: TextInputType.phone,
                            nextFocus: codeFocusNode,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: AuthField(
                            hintText: "Code",
                            controller: codeController,
                            focusNode: codeFocusNode,
                            textInputType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer2<StudentProvider, DropdownProvider>(
                          builder:
                              (context, studentProvider, dropdownProvider, _) {
                            return SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.427,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate Data

                                  studentProvider.searchStudent(
                                    usernameController.text.trim(),
                                    mobileNumberController.text.trim(),
                                    dropdownProvider.selectedGender,
                                    codeController.text.trim(),
                                    dropdownProvider.selectedYear,
                                    context,
                                  );

                                  // Show Snack Bar
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
                            );
                          },
                        ),
                        Consumer<DropdownProvider>(
                          builder: (context, dropdownProvider, _) {
                            return SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.427,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Clear All Fields
                                  usernameController.clear();
                                  mobileNumberController.clear();
                                  codeController.clear();
                                  dropdownProvider.setGender('Gender', context);
                                  dropdownProvider.setYear('Year');
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
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              // search result
              Consumer<StudentProvider>(
                builder: (context, studentProvider, _) {
                  return studentProvider.isSearchLoading
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: studentProvider.searchList.length,
                          itemBuilder: (context, index) {
                            final item = studentProvider.searchList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return DisplayUserDetails(
                                        studentId: item.studentId.toString(),
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 4.0, bottom: 4.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppColor.greyColor.withOpacity(0.2),
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 46.5,
                                      height: 46.5,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            item.studentProfile.toString(),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          limitedText(
                                            item.studentName.toString(),
                                            15,
                                          ),
                                          style: myTextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.blackColor,
                                          ),
                                        ),
                                        Text(
                                          item.studentMobile.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: AppColor.blackColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  sendMessageToWhatsApp(
                                                    message.data![0].whatsapp
                                                        .toString(),
                                                    context,
                                                    item.studentMobile
                                                        .toString(),
                                                  );
                                                },
                                                child: const SvgImage(
                                                  url: 'assets/svg/message.svg',
                                                  height: 30,
                                                )),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                                onTap: () {
                                                  sendMessageToWhatsApp(
                                                    message.data![1].whatsapp
                                                        .toString(),
                                                    context,
                                                    item.studentMobile
                                                        .toString(),
                                                  );
                                                },
                                                child: const SvgImage(
                                                  url:
                                                      'assets/svg/whatsapp.svg',
                                                  height: 30,
                                                )),
                                            const SizedBox(width: 5),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          item.studentCode.toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: AppColor.blackColor
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
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
}
