import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpms/main.dart';

class AuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future<bool> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (firebaseError) {
      throw handleNetworkError(firebaseError.message.toString());
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password, String name, String phone) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      await _firestore.collection('users').doc(userCredential.user?.uid).set({'email': email, 'name': name, 'phone': phone, 'displayImage': null});

      return true;
    } on FirebaseAuthException catch (firebaseError) {
      throw handleNetworkError(firebaseError.message.toString());
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<bool> updatePassword(String password) async {
    try {
      await _auth.currentUser?.updatePassword(password);

      return true;
    } on FirebaseAuthException catch (firebaseError) {
      throw handleNetworkError(firebaseError.message.toString());
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future<bool> updateProfileValues(String name, String phone) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
        'name': name,
        'phone': phone,
      });
      return true;
    } on FirebaseAuthException catch (firebaseError) {
      throw handleNetworkError(firebaseError.message.toString());
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future uploadProfilePicture(User user, File profilePicture) async {
    try {
      UploadTask uploadTask = _storage.ref().child('userProfilePictures/${user.uid}/displayImage.jpg').putFile(profilePicture);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      return downloadURL;
    } on FirebaseAuthException catch (firebaseError) {
      throw handleNetworkError(firebaseError.message.toString());
    } catch (e) {
      throw "Something went wrong";
    }
  }

  Future updateProfilePictureInFireStore() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        loader.show();
        String uploadPath = await uploadProfilePicture(_auth.currentUser!, File(image.path));
        await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
          'displayImage': uploadPath,
        });
        await _auth.currentUser?.updatePhotoURL(uploadPath);
        loader.hide();
        return uploadPath;
      } on FirebaseAuthException catch (firebaseError) {
        loader.hide();

        throw handleNetworkError(firebaseError.message.toString());
      } catch (e) {
        loader.hide();
        throw "Something went wrong";
      }
    }
  }

  signOut() {
    _auth.signOut();
  }

  String handleNetworkError(String firebaseErrorString) {
    if (firebaseErrorString.contains("network error")) {
      return "Network Error. Please check Your connection";
    } else {
      return firebaseErrorString;
    }
  }
}
