// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'dart:developer';

import 'package:dev_dandiya/Screen/home_screen.dart';
import 'package:dev_dandiya/Screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/session_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<SessionProvider>(context, listen: false).fetchSessions();
    _navigateToHome();
  }

  _navigateToHome() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? action = prefs.getString('auth');
    log('action: $action');
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            action == 'LoggedIn' ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffffa89e), Color(0xffabecd6)],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: SizedBox(
            height: 200,
            child: Image(
              image: AssetImage('assets/logo.gif'),
            ),
          ),
        ),
      ),
    );
  }
}
