import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mini_project/app/components/background2.dart';
import 'package:mini_project/app/data/UserCurrent.dart';
import 'package:mini_project/app/modules/login/controllers/login_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final LoginController controllerUser = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Background2(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    StreamBuilder<UserCurrent?>(
                      stream: controllerUser.getCurrentUserStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final user = snapshot.data;
                          if (user != null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Hello, ${user.name}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        const Text("How's your day going?",
                                            style: TextStyle(fontSize: 14))
                                      ],
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      backgroundImage: NetworkImage(user
                                              .image ??
                                          'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                                    )
                                  ],
                                ),
                                const Divider(),
                                Text(
                                  'My Email: ${user.email}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'My Phone Number: ${user.phoneNumber}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'My Address: ${user.address}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                // Tampilkan gambar profil jika tersedia
                              ],
                            );
                          } else {
                            return const Text('No user currently logged in.');
                          }
                        }
                      },
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffD567CD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        onPressed: () {
                          controller.saveImage();
                        },
                        child: const Text(
                          "Upload foto",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.logout();
                      },
                      child: Text("Logout"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
