import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpms/main.dart';
import 'package:kpms/screens/login_screen.dart';
import 'package:kpms/widgets/back_button.dart';
import 'package:kpms/widgets/custom_textfield.dart';
import 'package:kpms/widgets/primary_button.dart';

import '../controllers/authentication_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Signup Screen',
        home: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign Up',
                              style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 42),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: CustomBackButton(
                            context: context,
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(75))),
                      width: MediaQuery.sizeOf(context).width,
                      child: const SignUpForm(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthenticationController _authController = Get.put(AuthenticationController());

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 20.0),
        CustomTextField(
          controller: nameController,
          label: "Name",
          hintText: "Enter name",
        ),
        const SizedBox(height: 20.0),
        CustomTextField(
          controller: phoneController,
          label: "Phone",
          textInputType: TextInputType.phone,
          hintText: "Enter phone",
        ),
        const SizedBox(height: 20.0),
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
          needObscureToggle: false,
        ),
        const SizedBox(height: 20.0),
        CustomTextField(
          controller: cPasswordController,
          label: "Confirm Password",
          hintText: "Enter confirm password",
          isObscureText: true,
          needObscureToggle: false,
        ),
        const SizedBox(height: 20.0),
        const SizedBox(height: 20.0),
        PrimaryButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            String? errorString = validateSignUpForm();
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
            bool isSignUpSuccess = await _authController.signUpWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim(), nameController.text.trim(), phoneController.text.trim());
            loader.hide();
            if (isSignUpSuccess) {
              Fluttertoast.showToast(msg: "Sign Up Success", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
              if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            } else {
              Fluttertoast.showToast(msg: "Error", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
            }
          },
          label: 'Sign Up',
        ),
        const SizedBox(height: 10.0),
      ]),
    );
  }

  String? validateSignUpForm() {
    if (nameController.text.trim().isEmpty) {
      return "Enter Name";
    }
    if (phoneController.text.trim().isEmpty) {
      return "Enter Phone";
    }
    if (emailController.text.trim().isEmpty) {
      return "Enter Email";
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim())) {
      return "Enter Valid Email";
    }
    if (passwordController.text.trim().isEmpty) {
      return "Enter Password";
    }
    if (passwordController.text.trim().length < 8) {
      return "Password must be atleast 8 characters long";
    }
    if (cPasswordController.text.trim().isEmpty) {
      return "Enter Confirm Password";
    }
    if (cPasswordController.text.trim() != passwordController.text.trim()) {
      return "Confirm Password not matching";
    }
    return null;
  }
}
