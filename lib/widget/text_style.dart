import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/provider/home_provider.dart';
import 'package:dev_dandiya/provider/location_provider.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

TextStyle myTextStyle({
  required Color color,
  required double fontSize,
  required FontWeight fontWeight,
}) {
  return GoogleFonts.poppins(
    fontSize: 16,
    color: color,
    fontWeight: FontWeight.w500,
  );
}

String stripHtmlTags(String htmlString) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlString.replaceAll(exp, '');
}

String limitedText(String text, int maxLength) {
  // Check if the text exceeds the maximum length
  if (text.length > maxLength) {
    return '${text.substring(0, maxLength)}...'; // Add ellipsis to indicate truncation
  }
  return text; // Return the original text if it's within the limit
}


void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: myTextStyle(
          color: AppColor.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    ),
  );
}


void initializeData(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    String session = Provider.of<SessionProvider>(context, listen: false)
            .getSelectedSession()
            ?.session ??
        '2024';
    String location = Provider.of<LocationProvider>(context, listen: false)
            .getSelectedLocation()
            ?.locationId ??
        '1';
    await Provider.of<HomeProvider>(context, listen: false)
        .loadData(sessionId: session, locationId: location);
  });
}
