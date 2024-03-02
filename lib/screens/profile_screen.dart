import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kpms/controllers/profile_controller.dart';
import 'package:kpms/main.dart';
import 'package:kpms/screens/login_screen.dart';
import 'package:kpms/widgets/custom_textfield.dart';

import '../controllers/authentication_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthenticationController _authController = AuthenticationController();
  final ProfileController _profileController = Get.put(ProfileController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isEditing = false;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _profileController.updateDisplayImage(_authController.getUser()?.photoURL ?? "");
    _profileController.updateName(_authController.getUser()?.displayName ?? "-");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          flexibleSpace: SafeArea(
            child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Profile',
                      style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 42),
                    ),
                    const Spacer(),
                    Obx(() {
                      return !_profileController.isEditing.value
                          ? IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _profileController.setEditingMode();
                              },
                            )
                          : TextButton(
                              onPressed: () async {
                                String? errorString = validate();
                                if (errorString == null) {
                                  loader.show();
                                  await _authController.updateProfileValues(nameController.text.trim(), phoneController.text.trim()).then((value) async {
                                    if (passwordController.text.trim().isNotEmpty) {
                                      return await _authController.updatePassword(passwordController.text.trim()).then((value) {
                                        _profileController.stopEditingMode();
                                        _profileController.updateName(nameController.text.trim());
                                        loader.hide();
                                        Fluttertoast.showToast(msg: "Profile Updated Successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                      }).catchError((e) {
                                        throw e;
                                      });
                                    } else {
                                      loader.hide();
                                      _profileController.updateName(nameController.text.trim());
                                      _profileController.stopEditingMode();
                                      passwordController.clear();
                                      cPasswordController.clear();
                                      Fluttertoast.showToast(msg: "Profile Updated Successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                    }
                                  }).catchError((onError) {
                                    loader.hide();
                                    Fluttertoast.showToast(msg: onError, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                  });
                                } else {
                                  Fluttertoast.showToast(msg: errorString, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                                }
                              },
                              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)), child: Text("Save", style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white))));
                    }),
                    const SizedBox(
                      width: 8,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _authController.signOut();
                        Fluttertoast.showToast(msg: "Sign out Success", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                    ),
                  ],
                )),
          )),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                profilePicture(context),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(32, 64, 32, 16),
                  clipBehavior: Clip.hardEdge,
                  constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height - 200 - 50),
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(75), topRight: Radius.circular(75))),
                  child: Column(children: [
                    Container(
                      color: Colors.white,
                      child: FutureBuilder<DocumentSnapshot>(
                          future: _firestore.collection('users').doc(_authController.getUser()?.uid).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.red,
                              ));
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }
                            var userData = snapshot.data?.data() as Map<String, dynamic>;
                            nameController.text = userData['name'];
                            emailController.text = userData['email'];
                            phoneController.text = userData['phone'];
                            return Column(
                              children: [
                                Obx(() => CustomTextField(
                                      controller: nameController,
                                      label: "Name",
                                      hintText: "Enter name",
                                      isEnabled: _profileController.isEditing.value,
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomTextField(
                                  controller: emailController,
                                  label: "Email",
                                  hintText: "Enter email",
                                  isEnabled: false,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() => CustomTextField(
                                      controller: phoneController,
                                      label: "Phone",
                                      hintText: "Enter phone",
                                      textInputType: TextInputType.phone,
                                      isEnabled: _profileController.isEditing.value,
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() {
                                  return _profileController.isEditing.value
                                      ? CustomTextField(
                                          controller: passwordController,
                                          label: "Password",
                                          hintText: "Enter password",
                                          isEnabled: _profileController.isEditing.value,
                                          isObscureText: true,
                                        )
                                      : const SizedBox();
                                }),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() {
                                  return _profileController.isEditing.value
                                      ? CustomTextField(
                                          controller: cPasswordController,
                                          label: "Confirm Password",
                                          hintText: "Enter confirm password",
                                          isEnabled: _profileController.isEditing.value,
                                          isObscureText: true,
                                          needObscureToggle: false,
                                        )
                                      : const SizedBox();
                                }),
                              ],
                            );
                          }),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? validate() {
    if (nameController.text.trim().isEmpty) {
      return "Name cannot be empty";
    } else if (phoneController.text.trim().isEmpty) {
      return "Phone cannot be empty";
    } else if (passwordController.text.trim().isNotEmpty) {
      if (cPasswordController.text.trim() != passwordController.text.trim()) {
        return "Password and Confirm Password should be same";
      }
      if (passwordController.text.trim().length < 8) {
        return "Password must be atleast 8 characters long";
      }
    }
    return null;
  }

  Widget profilePicture(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Obx(() => CachedNetworkImage(
                imageUrl: _profileController.displayImage.value,
                imageBuilder: (context, imageProvider) => Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) {
                  return ProfilePicture(
                    name: _profileController.name.value,
                    radius: 31,
                    fontsize: 21,
                  );
                },
              )),
          Positioned(
              bottom: 0,
              right: -25,
              child: RawMaterialButton(
                onPressed: () {
                  _authController.updateProfilePictureInFireStore().then((value) {
                    _profileController.updateDisplayImage(value);
                    Fluttertoast.showToast(msg: "Profile Picture Updated Successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                  }).catchError((onError) {
                    Fluttertoast.showToast(msg: "Error While Uploading Profile Picture", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
                  });
                },
                elevation: 2.0,
                fillColor: const Color(0xFFF5F6F9),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.blue,
                ),
              )),
        ],
      ),
    );
  }
}
