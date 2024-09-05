import 'package:dev_dandiya/const/color.dart';
import 'package:dev_dandiya/widget/text_style.dart';
import 'package:flutter/material.dart';

void showDeletionPopup(
    BuildContext context, String name, VoidCallback deleteTap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Confirm Deletion',
          style: myTextStyle(
            color: AppColor.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this $name?',
          style: myTextStyle(
            color: AppColor.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              'Cancel',
              style: myTextStyle(
                color: AppColor.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          TextButton(
            onPressed: deleteTap,
            child: Text(
              'Delete',
              style: myTextStyle(
                color: AppColor.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    },
  );
}
