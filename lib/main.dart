import 'package:dev_dandiya/Screen/splash_screeen.dart';
import 'package:dev_dandiya/provider/dropdown_provider.dart';
import 'package:dev_dandiya/provider/event_provider.dart';
import 'package:dev_dandiya/provider/home_provider.dart';
import 'package:dev_dandiya/provider/login_provider.dart';
import 'package:dev_dandiya/provider/payment_provider_display_user.dart';
import 'package:dev_dandiya/provider/session_provider.dart';
import 'package:dev_dandiya/provider/student_provider.dart';
import 'package:dev_dandiya/provider/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/location_provider.dart';
import 'provider/payment_provider_add_user.dart';
import 'provider/user_details_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => LocationProvider()..fetchLocations()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => GenderProvider()),
        ChangeNotifierProvider(create: (_) => PaymentMethodProvider()),
        ChangeNotifierProvider(create: (_) => PaymentTypeProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => StudentProvider(context)),
        ChangeNotifierProvider(create: (_) => UserDetailProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider(context)),
        ChangeNotifierProvider(create: (_) => DropdownProvider()),
        ChangeNotifierProvider(create: (_) => UpdateLoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dev Dandiya',
      home: SplashScreen(),
    );
  }
}
