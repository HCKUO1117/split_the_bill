import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/user_model.dart';
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

  UserModel user = UserModel();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Reference storageRef = FirebaseStorage.instance.ref();

  ///載入user資料
  void init() {
    user.uid = Preferences.getString(Constants.uid, '');
    storageRef = FirebaseStorage.instance.ref(user.uid);
    users.doc(user.uid).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
          user.name = data['name'];
          user.photoUrl = data['avatar'];
          user.backgroundImage = data['background'];
          user.intro = data['intro'];
        } else {
          users.doc(user.uid).set({
            'name': '',
            'avatar': '',
            'background': '',
            'intro': '',
          });
        }
        notifyListeners();
      },
      onError: (e) {
        print(e);
      },
    );
  }

  ///更新用戶資料
  Future<void> updateProfile({
    required String name,
    required File? profile,
    required File? background,
    required String intro,
    required Function(void) onSuccess,
    required Function(dynamic) onError,
  }) async {
    String avatarUrl = user.photoUrl;
    String backgroundUrl = user.backgroundImage;
    if (profile != null) {
      bool success = false;
      final avatarRef = storageRef.child('${user.uid}-avatar.jpg');
      await avatarRef.putFile(profile).then(
        (TaskSnapshot taskSnapshot) {
          success = true;
        },
        onError: (e) {},
      );
      if (success) {
        avatarUrl = await avatarRef.getDownloadURL();
      }
    }
    if (background != null) {
      bool success = false;
      final backgroundRef = storageRef.child('${user.uid}-background.jpg');
      await backgroundRef.putFile(background).then(
        (TaskSnapshot taskSnapshot) {
          success = true;
        },
        onError: (e) {},
      );
      if (success) {
        backgroundUrl = await backgroundRef.getDownloadURL();
      }
    }

    await users.doc(user.uid).update({
      'name': name,
      'avatar': avatarUrl,
      'background': backgroundUrl,
      'intro': intro,
    }).then(
      onSuccess,
      onError: onError,
    );
  }

  ///更新名字
  Future<void> updateName({
    required String name,
    required Function(void) onSuccess,
    required Function(dynamic) onError,
    required Function onTimeOut,
  }) async {
    await users
        .doc(user.uid)
        .update({'name': name})
        .then(
          onSuccess,
          onError: onError,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            onTimeOut.call();
          },
        );
  }

  ///更新介紹
  Future<void> updateIntro({
    required String intro,
    required Function(void) onSuccess,
    required Function(dynamic) onError,
    required Function onTimeOut,
  }) async {
    await users
        .doc(user.uid)
        .update({'intro': intro})
        .then(
          onSuccess,
          onError: onError,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            onTimeOut.call();
          },
        );
  }

  ///更新大頭照
  Future<void> updateAvatar({
    required File avatar,
    required Function(void) onSuccess,
    required Function(dynamic) onError,
    required Function onTimeOut,
  }) async {
    String avatarUrl = user.photoUrl;

    bool success = false;
    final avatarRef = storageRef.child('${user.uid}-avatar.jpg');
    await avatarRef.putFile(avatar).then(
      (TaskSnapshot taskSnapshot) {
        success = true;
      },
      onError: onError,
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        onTimeOut.call();
      },
    );
    if (!success) {
      return;
    }
    avatarUrl = await avatarRef.getDownloadURL();
    await users.doc(user.uid).update({'avatar': avatarUrl}).then(
      onSuccess,
      onError: onError,
    );
  }

  ///更新背景照
  Future<void> updateBackground({
    required File background,
    required Function(void) onSuccess,
    required Function(dynamic) onError,
    required Function onTimeOut,
  }) async {
    String backgroundUrl = user.backgroundImage;

    bool success = false;
    final avatarRef = storageRef.child('${user.uid}-background.jpg');
    await avatarRef.putFile(background).then(
          (TaskSnapshot taskSnapshot) {
        success = true;
      },
      onError: onError,
    ).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        onTimeOut.call();
      },
    );
    if (!success) {
      return;
    }
    backgroundUrl = await avatarRef.getDownloadURL();
    await users.doc(user.uid).update({'background': backgroundUrl}).then(
      onSuccess,
      onError: onError,
    );
  }

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

  ///匿名帳號轉正
  Future<String?> linkAnonymousAccount(
    LoginType type, {
    String? email,
    String? password,
  }) async {
    ///email
    if (type == LoginType.email) {
      try {
        final credential = EmailAuthProvider.credential(
          email: email!,
          password: password!,
        );

        final userCredential =
            await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        await Preferences.setString(Constants.uid, userCredential?.user?.uid ?? '');
        await Preferences.setString(Constants.loginType, LoginType.email.name);
      } on FirebaseAuthException catch (e) {
        return e.code;
      } catch (e) {
        return e.toString();
      }
      return null;
    }

    ///google
    if (type == LoginType.google) {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();

        googleSignInAccount = await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount!.authentication;

          final credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          );
          final userCredential =
              await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
          await Preferences.setString(Constants.uid, userCredential?.user?.uid ?? '');
          await Preferences.setString(Constants.loginType, LoginType.email.name);
        }
      } on FirebaseAuthException catch (e) {
        return e.code;
      } catch (e) {
        return e.toString();
      }
      return null;
    }
    return null;
  }
}
