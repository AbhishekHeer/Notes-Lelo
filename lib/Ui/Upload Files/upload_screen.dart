import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/Get/button_color.dart';
import 'package:notes_app/Ui/Upload%20Files/upload_tofirebase.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

TextEditingController collegename = TextEditingController();
TextEditingController brach = TextEditingController();
TextEditingController sem = TextEditingController();
TextEditingController file = TextEditingController();
File? pdf;

ButtonColorController color = Get.put(ButtonColorController());

@override
void initState() {
  file.text = "Choose File";
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('text'),
          centerTitle: true,
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.height * .05),
                    child: Text(
                      'Upload File !!',
                      style: GoogleFonts.poppins(fontSize: Get.width * .06),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Get.height * .04,
                    horizontal: Get.width * .05,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      if (collegename.text.isEmpty ||
                          brach.text.isEmpty ||
                          sem.text.isEmpty ||
                          pdf?.path == null) {
                        color.change(true);
                      } else {
                        color.change(false);
                      }
                    },
                    controller: collegename,
                    decoration: InputDecoration(
                        label: const Text('College Name'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Get.width * .05))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * .05,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      if (collegename.text.isEmpty ||
                          brach.text.isEmpty ||
                          sem.text.isEmpty ||
                          pdf?.path == "") {
                        color.change(true);
                      } else {
                        color.change(false);
                      }
                    },
                    controller: brach,
                    decoration: InputDecoration(
                        // hintText: 'Branch',
                        label:
                            const Text('Subject For eg :ECE ,CS ,EE ,IT ,CSE'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Get.width * .05))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Get.height * .04,
                    horizontal: Get.width * .05,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (collegename.text.isEmpty ||
                          brach.text.isEmpty ||
                          sem.text.isEmpty ||
                          pdf?.path == "") {
                        color.change(true);
                      } else {
                        color.change(false);
                      }
                    },
                    controller: sem,
                    decoration: InputDecoration(
                        label: const Text('Semester For eg :1, 2, 3, 4, 5, 6'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Get.width * .05))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Get.width * .05,
                  ),
                  child: TextField(
                    controller: file,
                    onTap: () async {
                      getFile(
                        file,
                      );
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                        prefix: Padding(
                          padding: EdgeInsets.only(
                              right: Get.width * .02, left: Get.width * .02),
                          child: const Icon(
                            FontAwesomeIcons.filePdf,
                            color: Colors.red,
                          ),
                        ),
                        hintText: 'Choose File',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Get.width * .05))),
                  ),
                ),
                SizedBox(
                  height: Get.height * .06,
                ),
                InkWell(
                  onTap: () {
                    if (color.color.isTrue) {
                      Upload().uploadfile(pdf!.absolute, collegename, brach,
                          sem, context, file);
                    } else if (brach.text.length < 3) {
                      Get.snackbar('Error', "Please Use Short Form Of Branch ");
                    } else if (sem.text.length > 1) {
                      Get.snackbar('Error', "Sem Is Not Greater Than 10");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Row(
                        children: [Text('Error')],
                      )));
                    }
                  },
                  child: Container(
                    width: Get.width * .76,
                    height: Get.height * .07,
                    decoration: BoxDecoration(
                        gradient: color.color.value == true
                            ? const LinearGradient(
                                colors: [Colors.blueAccent, Colors.pinkAccent],
                              )
                            : const LinearGradient(colors: [
                                Color.fromARGB(255, 250, 249, 249),
                                Colors.grey
                              ]),
                        borderRadius: BorderRadius.circular(Get.width * .05)),
                    child: Center(
                        child: Text(
                      'Upload',
                      style: GoogleFonts.poppins(
                          fontSize: Get.width * .045,
                          fontWeight: FontWeight.w700),
                    )),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  getFile(TextEditingController filecont) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowMultiple: false,
          allowedExtensions: ['pdf']);

      setState(() {
        if (result != null) {
          filecont.text = result.names.toString();
          pdf = File(result.files.first.path!);
          // pdf = File(result.files.first.path);
          // filecont.text = pdf.absolute.toString();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Row(
                children: [Text('No File Picked'), Icon(Icons.error)],
              )));
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
