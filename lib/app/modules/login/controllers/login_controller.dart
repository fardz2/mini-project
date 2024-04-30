import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/app/data/UserCurrent.dart';
import 'package:mini_project/app/routes/app_pages.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Stream<User?> get streamAuthStatus =>
      FirebaseAuth.instance.authStateChanges();
  String? validationEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email not valid';
    }
    return null;
  }

  String? validationPassword(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be longer than 6 characters.\n';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Uppercase letter is missing.\n';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Lowercase letter is missing.\n';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Digit is missing.\n';
    }

    if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      return 'Special character is missing.\n';
    }

    return null;
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar('Success', 'User logged in successfully');
      Get.offAllNamed(Routes.HOME);
      emailController.text = '';
      passwordController.text = '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('wrong email');
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('wrong password');
        Get.snackbar('Error', 'Wrong password provided for that user.');
      } else if (e.code == 'too-many-requests') {
        print('too-many-requests');
        Get.snackbar('Error', 'Too many requests. Try again later.');
      }
      print(e.code);
    } catch (e) {
      print(e);
    }
  }

  Stream<UserCurrent?> getCurrentUserStream() async* {
    // Dapatkan stream perubahan status otentikasi pengguna
    Stream<User?> authStateChanges = auth.authStateChanges();

    await for (User? firebaseUser in authStateChanges) {
      if (firebaseUser != null) {
        // Dapatkan referensi dokumen pengguna dari Firestore
        DocumentReference userRef =
            firestore.collection('users').doc(firebaseUser.uid);

        yield* userRef.snapshots().map((snapshot) {
          if (snapshot.exists) {
            String? email = firebaseUser.email;

            return UserCurrent(
              id: firebaseUser.uid,
              name: snapshot['name'] as String,
              email: email,
              phoneNumber: snapshot['phoneNumber'] as String,
              address: snapshot['address'] as String,
              image: snapshot['images'],
            );
          } else {
            print('User document does not exist.');
            return null;
          }
        });
      } else {
        print('No user currently logged in.');
        yield null;
      }
    }
  }

  Future<void> updatePhoto(String url) async {
    final user = FirebaseAuth.instance.currentUser;
    await firestore.collection('users').doc(user!.uid).update({'images': url});
  }
}
