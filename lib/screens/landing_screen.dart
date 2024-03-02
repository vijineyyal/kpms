import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kpms/screens/profile_screen.dart';

import '../controllers/authentication_controller.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  final AuthenticationController _authController = AuthenticationController();

  SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Check if the user is already logged in after 3 seconds
    Timer(const Duration(seconds: 2), () {
      if (_authController.isUserSignedIn()) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });

    return Scaffold(
      body: Center(
          child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width / 4,
        backgroundImage: const AssetImage(
          "assets/images/krish2.jpeg",
        ),
      )),
    );
  }
}
