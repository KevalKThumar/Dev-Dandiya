// ignore_for_file: use_build_context_synchronously

import 'package:dev_dandiya/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../const/color.dart';
import '../provider/session_provider.dart';
import '../widget/session_selection_dialog.dart';
import '../widget/text_style.dart';

class WhatsAppSetting extends StatefulWidget {
  const WhatsAppSetting({super.key});

  @override
  State<WhatsAppSetting> createState() => _WhatsAppSettingState();
}

class _WhatsAppSettingState extends State<WhatsAppSetting> {
  TextEditingController instructionMessageController = TextEditingController();
  TextEditingController welcomeMessageController = TextEditingController();

  FocusNode instructionMessageFocusNode = FocusNode();
  FocusNode welcomeMessageFocusNode = FocusNode();

  @override
  void dispose() {
    instructionMessageController.dispose();
    welcomeMessageController.dispose();
    instructionMessageFocusNode.dispose();
    welcomeMessageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final sessionProvider =
        Provider.of<SessionProvider>(context).getSelectedSession();
    String? currentYear = sessionProvider?.session ??
        Provider.of<SessionProvider>(context).sessions[1].session;
    welcomeMessageController.text =
        homeProvider.message.data![0].whatsapp.toString();
    instructionMessageController.text =
        homeProvider.message.data![1].whatsapp.toString();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.center,
                  child: Text('WhatsApp Setting',
                      style: GoogleFonts.roboto(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        color: AppColor.blackColor,
                      )),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'WhatsApp Message',
                  style: myTextStyle(
                      fontSize: 18.0,
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: welcomeMessageController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                        16), // Adjust padding for better readability
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide
                          .none, // Add a slight border for better visibility
                      borderRadius: BorderRadius.circular(4), // Rounded border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide.none, // Highlight border when focused
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintStyle: myTextStyle(
                      color: const Color(0xff5F259E).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    hintText: 'Enter your message here...',
                    filled: true,
                    fillColor: const Color(0xff5F259E).withOpacity(
                        0.05), // Slight background tint for text area
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Allows for an indefinite number of lines
                  scrollPhysics:
                      const BouncingScrollPhysics(), // More natural scrolling behavior for multiline input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'message is required';
                    }
                    return null;
                  },
                  focusNode: welcomeMessageFocusNode,
                  onFieldSubmitted: (value) {
                    welcomeMessageFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(instructionMessageFocusNode);
                  },
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Instruction Message',
                  style: myTextStyle(
                      fontSize: 18.0,
                      color: AppColor.blackColor,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: instructionMessageController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                        16), // Adjust padding for better readability
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide
                          .none, // Add a slight border for better visibility
                      borderRadius: BorderRadius.circular(4), // Rounded border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide.none, // Highlight border when focused
                      borderRadius: BorderRadius.circular(4),
                    ),
                    hintStyle: myTextStyle(
                      color: const Color(0xff5F259E).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    hintText: 'Enter your message here...',
                    filled: true,
                    fillColor: const Color(0xff5F259E).withOpacity(
                        0.05), // Slight background tint for text area
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null, // Allows for an indefinite number of lines
                  scrollPhysics:
                      const BouncingScrollPhysics(), // More natural scrolling behavior for multiline input
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Instruction message is required';
                    }
                    return null;
                  },
                  focusNode: instructionMessageFocusNode,
                  onFieldSubmitted: (value) {
                    instructionMessageFocusNode.unfocus();
                    FocusScope.of(context)
                        .requestFocus(welcomeMessageFocusNode);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.42,
                      child: ElevatedButton(
                        onPressed: () {
                          if (instructionMessageController.text.isNotEmpty &&
                              welcomeMessageController.text.isNotEmpty) {
                            homeProvider.updateMessage(
                              instructionMessageController.text,
                              welcomeMessageController.text,
                              context,
                            );
                            showSnackBar(
                              context,
                              "Messages updated successfully",
                              const Color(0xff5F259E),
                            );
                            instructionMessageController.clear();
                            welcomeMessageController.clear();
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please fill all the fields',
                                  style: myTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(10),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          backgroundColor: const Color(0xff5F259E),
                        ),
                        child: Text(
                          'Submit',
                          style: myTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.42,
                      child: ElevatedButton(
                        onPressed: () {
                          instructionMessageController.clear();
                          welcomeMessageController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text('Clear',
                            style: myTextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
