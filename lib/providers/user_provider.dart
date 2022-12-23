import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';
import 'package:split_the_bill/utils/show_snack.dart';

enum LoginType {
  email,
  google,
  anonymous,
}

extension LoginTypeEx on LoginType {
  String get name {
    switch (this) {
      case LoginType.email:
        return 'email';
      case LoginType.google:
        return 'google';
      case LoginType.anonymous:
        return 'anonymous';
    }
  }
}

class UserProvider extends ChangeNotifier {
  GoogleSignInAccount? googleSignInAccount;

  ///匿名登入
  Future<bool> signInWithAnonymously(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      await Preferences.setString(Constants.uid, userCredential.user?.uid ?? '');
      await Preferences.setString(Constants.loginType, LoginType.anonymous.name);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          ShowSnack.show(context, content: S.of(context).anonymouslyError);
          break;
        default:
          ShowSnack.show(context, content: S.of(context).unknownError);
      }
    }
    return false;
  }

  ///google登入
  Future<bool> signInWithGoogle(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        await Preferences.setString(Constants.uid, userCredential.user?.uid ?? '');
        await Preferences.setString(Constants.loginType, LoginType.google.name);
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ShowSnack.show(context,
              content: 'The account already exists with a different credential');
        } else if (e.code == 'invalid-credential') {
          ShowSnack.show(context,
              content: 'Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        ShowSnack.show(context, content: 'Error occurred using Google Sign In. Try again.');
      }
    }
    return false;
  }

  ///建立帳號
  Future<String?> createPasswordAccount({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Preferences.setString(Constants.uid, credential.user?.uid ?? '');
      await Preferences.setString(Constants.loginType, LoginType.email.name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return e.code;
      } else if (e.code == 'email-already-in-use') {
        return e.code;
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  ///email登入
  Future<String?> loginByPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await Preferences.setString(Constants.uid, credential.user?.uid ?? '');
      await Preferences.setString(Constants.loginType, LoginType.email.name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
      return e.code;
    }
    return null;
  }

  ///登出
  Future<void> signOut() async {
    await Preferences.setString(Constants.uid, '');
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
