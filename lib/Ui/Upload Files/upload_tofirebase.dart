import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/Ui/HomeScreen/homeScreen.dart';

class Upload {
  Future<void> uploadfile(
      File pdf,
      TextEditingController collegename,
      TextEditingController branch,
      TextEditingController sem,
      context,
      TextEditingController pdfname) async {
    showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: null,
            content: SizedBox(
              height: Get.height * .1,
              width: Get.width * .4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(
                      height: Get.height * .02,
                    ),
                    const Text('Uploading')
                  ],
                ),
              ),
            ),
          );
        });

    final store = FirebaseFirestore.instance.collection('pdf');

    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final ref = FirebaseStorage.instance.ref().child('pdf/$id.pdf');
    final task = await ref.putFile(pdf);
    final url = await task.ref.getDownloadURL();

    return store.doc(id).set({
      'id': id,
      'college name': collegename.text.toString(),
      'Subject': branch.text.toUpperCase(),
      "sem": sem.text.toString(),
      "file": url.toString(),
      "filename": pdfname.text.toString()
    }).whenComplete(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      collegename.clear();
      branch.clear();
      sem.clear();
      pdf.delete();
      pdfname.clear();
    }).onError((error, stackTrace) {
      Get.snackbar('Error', error.toString().substring(0, 20));
      throw Exception(error.toString());
    });
  }
}
