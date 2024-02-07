//google_sign_in: ^4.5.1
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app/Ui/Auth/Login.dart';

class AuthMethod {
  Future<UserCredential> signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    showAdaptiveDialog(
        context: context,
        builder: (context) => const AlertDialog(
              content: CircularProgressIndicator(),
            ));
    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

//flutter_facebook_auth: ^1.0.0

  Future<UserCredential> signInWithFacebook(context) async {
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.token);

    if (facebookAuthCredential.idToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
        children: [Text('Failed To Sign In'), Icon(Icons.error)],
      )));
    }

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  delete(context) async {
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.currentUser?.delete();
  }

  logout(context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }
}
