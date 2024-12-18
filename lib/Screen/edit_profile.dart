// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dev_dandiya/Screen/home_screen.dart';
import 'package:dev_dandiya/Screen/search_screen.dart';
import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/provider/user_provider.dart';
import 'package:dev_dandiya/widget/session_selection_dialog.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? studentProfile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  String? status;
  String? message;
  String? adminId;
  String? adminUsername;
  String? adminPassword;
  String? adminStatus;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    status = prefs.getString('status');
    message = prefs.getString('message');
    adminId = prefs.getString('admin_id');
    adminUsername = prefs.getString('admin_username');
    adminPassword = prefs.getString('admin_password');
    adminStatus = prefs.getString('admin_status');
    usernameController.text = adminUsername ?? '';
    passwordController.text = adminPassword ?? '';
    confirmPasswordController.text = adminPassword ?? '';
    // Use the retrieved data in your app
  }

  Future<void> _submitForm(BuildContext context) async {
    getUserData();
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (passwordController.text == confirmPasswordController.text) {
        context.read<UpdateLoginProvider>().updateLogin(
              loginId: adminId ?? '',
              loginName: usernameController.text,
              loginPassword: passwordController.text,
              context: context,
            );
      } else {
        showSnackBar(
          context,
          'Passwords and confirm password dosn\'t match',
          Colors.red,
        );
      }

      // edit profile
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

  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmTextNotifier =
      ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final sessionProvider =
        Provider.of<SessionProvider>(context).getSelectedSession();
    String? currentYear = sessionProvider?.session ??
        Provider.of<SessionProvider>(context).sessions[1].session;

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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Container(
                width: double.infinity,
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
                    const SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        style: myTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xffffa89e),
                        ),
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: myTextStyle(
                            color: const Color(0xffffa89e),
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffa89e),
                              width: 2,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffffa89e),
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
                              .requestFocus(passwordFocusNode);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _obscureTextNotifier,
                        builder: (context, obscureText, child) {
                          return TextFormField(
                            obscureText: obscureText,
                            style: myTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffffa89e),
                            ),
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: myTextStyle(
                                color: const Color(0xffffa89e),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffffa89e),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffffa89e),
                                  width: 2,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                splashColor:
                                    Colors.transparent, // Removes splash color
                                highlightColor: Colors
                                    .transparent, // Removes highlight color
                                icon: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Icon(
                                    obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xffffa89e),
                                    size: 22,
                                  ),
                                ),
                                onPressed: () {
                                  _obscureTextNotifier.value =
                                      !_obscureTextNotifier.value;
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            focusNode: passwordFocusNode,
                            onFieldSubmitted: (value) {
                              passwordFocusNode.unfocus();
                            },
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _obscureConfirmTextNotifier,
                        builder: (context, obscureText, child) {
                          return TextFormField(
                            obscureText: obscureText,
                            style: myTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffffa89e),
                            ),
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              labelStyle: myTextStyle(
                                color: const Color(0xffffa89e),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffffa89e),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffffa89e),
                                  width: 2,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                splashColor:
                                    Colors.transparent, // Removes splash color
                                highlightColor: Colors
                                    .transparent, // Removes highlight color
                                icon: Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Icon(
                                    obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xffffa89e),
                                    size: 22,
                                  ),
                                ),
                                onPressed: () {
                                  _obscureConfirmTextNotifier.value =
                                      !_obscureConfirmTextNotifier.value;
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            focusNode: confirmPasswordFocusNode,
                            onFieldSubmitted: (value) {
                              confirmPasswordFocusNode.unfocus();
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: context.watch<UpdateLoginProvider>().isLoading
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.38,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _submitForm(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffffa89e),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      'Update',
                                      style: myTextStyle(
                                        color: AppColor.whiteColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 140,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Clear All Fields
                                      usernameController.clear();
                                      passwordController.clear();
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
