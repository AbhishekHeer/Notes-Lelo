import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/Ui/Auth/Login.dart';
import 'package:notes_app/Ui/Auth/auth_method.dart';

class SettingBody extends StatelessWidget {
  SettingBody({super.key});

  final url = FirebaseAuth.instance.currentUser?.photoURL;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          // User card

          BigUserCard(
            settingColor: Colors.red,
            userName: FirebaseAuth.instance.currentUser?.displayName,
            userProfilePic: NetworkImage(url.toString()),
            // cardActionWidget: SettingsItem(
            //   icons: Icons.edit,
            //   iconStyle: IconStyle(
            //     withBackground: true,
            //     borderRadius: 50,
            //     backgroundColor: Colors.yellow[600],
            //   ),
            //   title: "Modify",
            //   subtitle: "",
            //   onTap: () {},
            // ),
          ),
          SettingsGroup(
            items: [
              SettingsItem(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Get.width * .02),
                        child: const Text('Contect With Developer'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: Get.width * .02),
                        child: const Icon(
                          Icons.error,
                          color: Colors.amber,
                        ),
                      )
                    ],
                  )));
                },
                icons: CupertinoIcons.pencil_outline,
                iconStyle: IconStyle(),
                title: 'API',
                subtitle: "Get Free API",
              ),
            ],
          ),
          SettingsGroup(
            items: [
              SettingsItem(
                onTap: () {},
                icons: Icons.info_rounded,
                iconStyle: IconStyle(
                  backgroundColor: Colors.purple,
                ),
                title: 'About',
                subtitle: "Learn more about Notes Leloo",
              ),
            ],
          ),
          // You can add a settings title
          SettingsGroup(
            settingsGroupTitle: "Account",
            items: [
              SettingsItem(
                onTap: () async {
                  await AuthMethod().logout(context);
                },
                icons: Icons.exit_to_app_rounded,
                title: "Sign Out",
              ),
              SettingsItem(
                onTap: () async {
                  await AuthMethod().delete(context);
                  Get.snackbar('Done', 'Delete Account Successfully ',
                      colorText: Colors.black,
                      backgroundColor: Colors.greenAccent);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                icons: CupertinoIcons.delete_solid,
                title: "Delete account",
                titleStyle: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
