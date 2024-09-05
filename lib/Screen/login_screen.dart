import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/widget/svg_url.dart';
import 'package:dev_dandiya/widget/text_form_field.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/login_provider.dart'; // Import your provider

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff5F259E), Color(0xffabecd6)],
                      stops: [0, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Form(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 90),
                          const SvgImage(
                            url: 'assets/svg/logo.svg',
                            height: 300,
                          ),
                          // Login Text
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(4),
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
                              children: [
                                Text(
                                  'Welcome To Dev Dandiya',
                                  style: myTextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff5F259E),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Email Textfield
                                AuthField(
                                  controller: emailController,
                                  focusNode: emailFocusNode,
                                  hintText: 'Email',
                                  textInputType: TextInputType.emailAddress,
                                  nextFocus: passwordFocusNode,
                                ),

                                const SizedBox(height: 20),

                                // Password Textfield
                                ValueListenableBuilder<bool>(
                                  valueListenable: _obscureTextNotifier,
                                  builder: (context, obscureText, child) {
                                    return TextFormField(
                                      style: myTextStyle(
                                          color: const Color(0xff5F259E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      controller: passwordController,
                                      focusNode: passwordFocusNode,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff5F259E)),
                                        ),
                                        hintText: 'Password',
                                        hintStyle: myTextStyle(
                                          color: const Color(0xff5F259E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        suffixIcon: IconButton(
                                          splashColor: Colors
                                              .transparent, // Removes splash color
                                          highlightColor: Colors
                                              .transparent, // Removes highlight color
                                          icon: Icon(
                                            obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: const Color(0xff5F259E),
                                            size: 22,
                                          ),
                                          onPressed: () {
                                            _obscureTextNotifier.value =
                                                !_obscureTextNotifier.value;
                                          },
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xff5F259E)
                                            .withOpacity(0.1),
                                        labelStyle: myTextStyle(
                                          fontSize: 18,
                                          color: const Color(0xff5F259E),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      obscureText: obscureText,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(passwordFocusNode);
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Login Button
                                loginProvider.isLoading
                                    ? const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xff5F259E),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.38,
                                            child: ElevatedButton(
                                              onPressed: loginProvider.isLoading
                                                  ? null
                                                  : () {
                                                      if (emailController.text
                                                              .isNotEmpty &&
                                                          passwordController
                                                              .text
                                                              .isNotEmpty) {
                                                        loginProvider.login(
                                                          emailController.text,
                                                          passwordController
                                                              .text,
                                                          context,
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Please enter email and password',
                                                              style:
                                                                  myTextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColor
                                                                    .whiteColor,
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 2),
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                          ),
                                                        );
                                                      }
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                backgroundColor:
                                                    const Color(0xff5F259E),
                                              ),
                                              child: Text(
                                                'Login',
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.38,
                                            child: ElevatedButton(
                                              onPressed: loginProvider.isLoading
                                                  ? null
                                                  : () {
                                                      // Clear All Fields
                                                      emailController.clear();
                                                      passwordController
                                                          .clear();
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
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

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
