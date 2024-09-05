import 'package:dev_dandiya/provider/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/color.dart';
import '../model/session_model.dart';
import '../provider/session_provider.dart';
import '../widget/text_style.dart';

class SessionSelectionDialog extends StatelessWidget {
  const SessionSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the current list of sessions and the selected session
    List<Data> sessionList = context.watch<SessionProvider>().sessions;
    Data? selectedSession = context.watch<SessionProvider>().selectedSession;

    // Safely set the initial value to the first session if no session is selected yet
    if (selectedSession == null && sessionList.isNotEmpty) {
      selectedSession = sessionList.first;
    }

    return AlertDialog(
      title: Center(
        child: Text(
          "Select Session",
          style: myTextStyle(
            color: AppColor.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        width: double.maxFinite,
        child: DropdownButton<Data>(
          value: selectedSession,
          isExpanded: true,
          onChanged: (Data? newValue) {
            if (newValue != null) {
              context.read<SessionProvider>().setSelectedSession(newValue);
              context.read<StudentProvider>().getCode(
                    context,
                    studentSession: newValue.session!,
                  );
              initializeData(context);
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          items: sessionList.map<DropdownMenuItem<Data>>((Data value) {
            return DropdownMenuItem<Data>(
              value: value,
              child: Center(
                child: Text(
                  value.session ?? '',
                  style: myTextStyle(
                    color: AppColor.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
