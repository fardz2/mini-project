import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_project/app/modules/login/controllers/login_controller.dart';
import 'package:mini_project/app/modules/login/views/login_view.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LoginController loginController = Get.find();
  File? _photo;
  void logout() async {
    await auth.signOut();
    Get.off(() => const LoginView());
  }

  Future<String> uploadFile() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery

    pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    _photo = File(pickedFile!.path);
    final storageReference =
        FirebaseStorage.instance.ref().child('profile/${_photo?.path}');
    await storageReference.putFile(_photo!);
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> saveImage() async {
    String imageURL = await uploadFile();
    loginController.updatePhoto(imageURL);
    Get.snackbar('Success', 'Upload photo is successfully');
    refresh();
  }
}
