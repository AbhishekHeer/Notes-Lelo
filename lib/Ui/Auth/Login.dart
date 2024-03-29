import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/Ui/Auth/auth_method.dart';
import 'package:notes_app/Ui/HomeScreen/homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * .3),
                child: Text(
                  'LOGIN',
                  style: GoogleFonts.poppins(
                      letterSpacing: Get.width * .01,
                      fontWeight: FontWeight.w600,
                      fontSize: Get.width * .07),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * .2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     AuthMethod()
                      //         .signInWithFacebook(context)
                      //         .then((value) {
                      //       Get.snackbar('Welcome',
                      //           'Welcome ${FirebaseAuth.instance.currentUser?.displayName}');
                      //       Navigator.pushReplacement(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const HomeScreen()),
                      //       );
                      //     });
                      //   },
                      //   icon: Icon(
                      //     FontAwesomeIcons.facebook,
                      //     color: Colors.blue,
                      //     size: Get.height * .05,
                      //   ),
                      // ),

                      IconButton(
                        onPressed: () {
                          AuthMethod().signInWithGoogle(context).then((value) {
                            Get.snackbar('Welcome',
                                'Welcome ${FirebaseAuth.instance.currentUser?.displayName}');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          });
                        },
                        icon: Icon(
                          FontAwesomeIcons.google,
                          size: Get.height * .04,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Get.height * .35),
                    child: Text(
                      'Version : 1.1.0',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: Get.width * .03,
                          letterSpacing: Get.width * .005),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
