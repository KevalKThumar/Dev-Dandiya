import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final Icon? prefixIcon;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final TextInputType textInputType;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.prefixIcon,
    required this.focusNode,
    this.nextFocus,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 40,
      child:TextFormField(
              style: myTextStyle(
                  color: const Color(0xff5F259E),
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              keyboardType: textInputType,
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff5F259E)),
                ),
                hintText: hintText,
                hintStyle: myTextStyle(
                  color: const Color(0xff5F259E),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0xff5F259E).withOpacity(0.1),
                prefixIcon: prefixIcon,
                labelStyle: myTextStyle(
                  fontSize: 18,
                  color: const Color(0xff5F259E),
                  fontWeight: FontWeight.w400,
                ),
              ),
              obscureText: isObscureText,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                if (nextFocus != null) {
                  FocusScope.of(context).requestFocus(nextFocus);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
            ),
    );
  }
}
