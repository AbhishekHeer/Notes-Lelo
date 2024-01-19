import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/Ui/Auth/Login.dart';
import 'package:notes_app/Ui/Auth/auth_method.dart';
import 'package:notes_app/Ui/HomeScreen/homeScreen.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

final db = FirebaseFirestore.instance.collection('pdf');

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverAppBar(
          actions: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  AuthMethod().delete(context).then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  });
                },
                icon: const Icon(
                  CupertinoIcons.person,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: Get.width * .04,
            ),
          ],
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Notes Lelo',
              style: GoogleFonts.poppins(fontSize: Get.width * .05),
            ),
            centerTitle: true,
            background: const Image(
              image: AssetImage('Assets/Image/book.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          expandedHeight: Get.height * .3,
          pinned: true,
          backgroundColor: Colors.black,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const SearchBar(),
          StreamBuilder(
            stream: db.snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('text'),
                );
              } else {
                return Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, childAspectRatio: 2),
                      itemBuilder: (context, index) {
                        final college = snapshot
                            .data?.docs[index]['college name']
                            .toString();
                        final text =
                            snapshot.data?.docs[index]['filename'].toString();
                        return Padding(
                          padding: EdgeInsets.only(
                              top: Get.width * .05,
                              left: Get.width * .03,
                              right: Get.width * .03),
                          child: Card(
                            color: Colors.grey,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * .03,
                                      vertical: Get.width * .08),
                                  child: const Icon(FontAwesomeIcons.filePdf),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Get.width * .04,
                                          left: Get.width * .03),
                                      child: Text(
                                        text!.length > 17
                                            ? "${text.substring(1, 16)}..."
                                            : text,
                                        style: GoogleFonts.poppins(
                                            fontSize: Get.width * .04,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Get.width * .06,
                                          top: Get.height * .01),
                                      child: Text(
                                        'Sem : ${snapshot.data?.docs[index]['sem'].toString()}',
                                        style: GoogleFonts.poppins(
                                            fontSize: Get.width * .04,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Get.width * .06,
                                          top: Get.height * .01),
                                      child: Text(
                                        'Branch : ${snapshot.data?.docs[index]['Subject'].toString()}',
                                        style: GoogleFonts.poppins(
                                            fontSize: Get.width * .04,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: Get.width * .06,
                                          top: Get.height * .01),
                                      child: Text(
                                        college!.length > 8
                                            ? " College :${college.substring(0, 8)}"
                                            : "College : $college",
                                        style: GoogleFonts.poppins(
                                            fontSize: Get.width * .04,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.width * .14,
                                      top: Get.width * .27),
                                  child: CircleAvatar(
                                    radius: Get.width * .06,
                                    backgroundColor: Colors.white,
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () async {
                                          FileDownloader.downloadFile(
                                            url: snapshot.data?.docs[index]
                                                ['file'],
                                            onDownloadCompleted: (path) async {
                                              File(path);

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.greenAccent,
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Done File Saved In Download'),
                                                          Icon(Icons.done)
                                                        ],
                                                      )));
                                            },
                                            onProgress: (fileName, progress) {
                                              showAdaptiveDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height:
                                                            Get.height * .05,
                                                        width: Get.width,
                                                        child: const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                    );
                                                  }));
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          CupertinoIcons.down_arrow,
                                          size: Get.width * .06,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
          ),
        ])),
      ],
    );
  }
}
