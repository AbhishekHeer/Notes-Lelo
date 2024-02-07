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

final _search = TextEditingController();

var searchdoc = '';
final db = FirebaseFirestore.instance.collection('pdf');

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
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
          //search document
          SizedBox(width: 0.0, height: Get.height * .03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .04),
            child: SearchBar(
              onChanged: (value) {
                setState(() {
                  searchdoc = value;
                });
              },
              controller: _search,
              hintText: 'Search Any Branch',
              trailing: [
                IconButton(
                    onPressed: () {
                      _search.clear();
                      setState(() {});
                    },
                    icon: const Icon(CupertinoIcons.clear)),
                SizedBox(width: Get.width * .02, height: 0.0),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.snapshots(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data?.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 2),
                  itemBuilder: (context, index) {
                    if (_search.text.isEmpty) {
                      final college =
                          snapshot.data?.docs[index]['college name'].toString();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.width * .1,
                                      right: Get.height * .01,
                                      bottom: Get.height * .02,
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
                                              showDialog(
                                                  barrierColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height:
                                                            Get.height * .09,
                                                        width: Get.width,
                                                        child: Column(
                                                          children: [
                                                            const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      .02,
                                                            ),
                                                            Text(progress
                                                                .toString()),
                                                          ],
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
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    if (snapshot.data!.docs[index]['Subject']
                        .toLowerCase()
                        .startsWith(searchdoc.toLowerCase().toString())) {
                      final college =
                          snapshot.data?.docs[index]['college name'].toString();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: Get.width * .1,
                                      right: Get.height * .01,
                                      bottom: Get.height * .02,
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
                                              showDialog(
                                                  barrierColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height:
                                                            Get.height * .09,
                                                        width: Get.width,
                                                        child: Column(
                                                          children: [
                                                            const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      .02,
                                                            ),
                                                            Text(progress
                                                                .toString()),
                                                          ],
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
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return null;
                  });
            }),
          ),
        ])),
      ],
    );
  }
}
