import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/Ui/HomeScreen/home_body.dart';
import 'package:notes_app/Ui/Setting/setting.dart';
import 'package:notes_app/Ui/Upload%20Files/upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

NotchBottomBarController _page = NotchBottomBarController();
int current = 0;

class _HomeScreenState extends State<HomeScreen> {
  List screens = [const HomeBody(), const SettingBody()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(current),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );
        },
        child: const Icon(CupertinoIcons.cloud_upload),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: Get.height * .08,
        activeColor: Colors.blueAccent,
        inactiveColor: Colors.grey,
        icons: const [
          CupertinoIcons.home,
          CupertinoIcons.person,
        ],
        activeIndex: current,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => setState(() => current = index),
        //other params
      ),
    );
  }
}
