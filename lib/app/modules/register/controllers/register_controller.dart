import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_project/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  //TODO: Implement LoginController
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validationEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Email not valid';
    }
    return null;
  }

  String? validationName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validationAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? validationPhonenumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phonenumber';
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

  String? validationconfirmPassword(String? value) {
    // Reset error message

    // Password length greater than 6
    if (value == null || value.isEmpty) {
      return 'Confirm password field must be filled';
    }
    if (value != passwordController.text) {
      return 'Confirm password not match';
    }

    // If there are no error messages, the password is valid
    return null;
  }

  void registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await firestore.collection('users').doc(userId).set({
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'images': userCredential.user?.photoURL
      });
      Get.snackbar('Success', 'User registered in successfully');
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('Error during registration: $e');
      // Handle errors here
    }
  }
}
