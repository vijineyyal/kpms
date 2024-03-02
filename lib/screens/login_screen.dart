import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpms/main.dart';
import 'package:kpms/screens/profile_screen.dart';
import 'package:kpms/screens/signup_screen.dart';
import 'package:kpms/widgets/custom_textfield.dart';
import 'package:kpms/widgets/primary_button.dart';

import '../controllers/authentication_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login Screen',
        home: Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      width: MediaQuery.sizeOf(context).width,
                      child: Image.asset("assets/images/krish2.jpeg"),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(75))),
                        width: MediaQuery.sizeOf(context).width,
                        child: const LoginForm(),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final AuthenticationController _authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.only(top: 16, bottom: 46),
              child: Text(
                'Login',
                style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 36),
              )),
          CustomTextField(
            controller: emailController,
            label: "Email",
            hintText: "Enter email",
          ),
          const SizedBox(height: 20.0),
          CustomTextField(
            controller: passwordController,
            label: "Password",
            hintText: "Enter password",
            isObscureText: true,
          ),
          const SizedBox(height: 20.0),
          const SizedBox(height: 20.0),
          PrimaryButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              String? errorString = validateLoginForm();
              if (errorString != null) {
                return Fluttertoast.showToast(
                  msg: errorString,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
              loader.show();
              await _authController.signInWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim(), context).then((value) {
                loader.hide();
                if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProfileScreen()));
              }).catchError((onError) {
                loader.hide();
                Fluttertoast.showToast(msg: onError, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
              });
            },
            label: 'Login',
          ),
          const SizedBox(height: 46.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Don\'t have an account?', style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
                },
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? validateLoginForm() {
    if (emailController.text.trim().isEmpty) {
      return "Enter Email";
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())) {
      return "Enter Valid Email";
    }
    if (passwordController.text.trim().isEmpty) {
      return "Enter Password";
    }
    return null;
  }
}
