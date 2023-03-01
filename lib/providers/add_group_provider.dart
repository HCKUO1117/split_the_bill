import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class AddGroupProvider with ChangeNotifier {
  bool loading = false;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  TextEditingController groupName = TextEditingController();

  String? error;

  File? photo;

  List<UserModel> members = [];

  Reference storageRef = FirebaseStorage.instance.ref();

  void addMember(UserModel userModel) {
    members.add(userModel);
    notifyListeners();
  }

  void createUnRealUser() {
    fireStore.collection('users').add({
      'name': '',
      'email': '',
      'avatar': '',
      'background': '',
      'intro': '',
      'groups': [],
      'friends': [],
      'events': [],
      'real': false,
      'crateAt': DateTime.now().microsecondsSinceEpoch,
    });
  }

  void removeMember(UserModel userModel) {
    members.removeWhere((element) => element.uid == userModel.uid);
    notifyListeners();
  }

  Future<bool> addGroupToDataBase(
    BuildContext context, {
    required Function onError,
  }) async {
    loading = true;
    notifyListeners();
    if (groupName.text.isEmpty) {
      error = S.of(context).nameNotFill;
      loading = false;
      notifyListeners();
      return false;
    }

    //TODO 需要優化(transaction)
    bool success = true;
    var response = await fireStore.collection('groups').add({
      'name': groupName.text,
      'admin': Preferences.getString(Constants.uid, ''),
      'createAt': DateTime.now().microsecondsSinceEpoch,
      'updateAt': DateTime.now().microsecondsSinceEpoch,
    }).catchError(
      () {
        onError.call();
        success = false;
        loading = false;
        notifyListeners();
      },
    );
    var userGroupRef = fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('groups')
        .doc(response.id);
    var userRef = fireStore
        .collection('groups')
        .doc(response.id)
        .collection('members')
        .doc(Preferences.getString(Constants.uid, ''));
    if (!success) return false;
    fireStore.runTransaction((transaction) async {
      transaction.set(userRef, {'admin': true});
      transaction.set(userGroupRef, {'admin': true});
      for (var element in members) {
        var groupRef =
            fireStore.collection('users').doc(element.uid).collection('groups').doc(response.id);
        var ref =
            fireStore.collection('groups').doc(response.id).collection('members').doc(element.uid);
        transaction.set(groupRef, {'admin': false});
        transaction.set(ref, {'admin': false});
      }
    });

    // fireStore
    //     .collection('users')
    //     .doc(Preferences.getString(Constants.uid, ''))
    //     .collection('groups')
    //     .doc(response.id)
    //     .set({});
    // fireStore
    //     .collection('groups')
    //     .doc(response.id)
    //     .collection('members')
    //     .doc(Preferences.getString(Constants.uid, ''))
    //     .set({});
    if (photo != null) {
      bool success = false;
      final avatarRef =
          storageRef.child('groups').child(response.id).child('${response.id}-avatar.jpg');
      await avatarRef.putFile(photo!).then(
        (TaskSnapshot taskSnapshot) {
          success = true;
        },
      );
      if (success) {
        String avatarUrl = await avatarRef.getDownloadURL();
        await fireStore.collection('groups').doc(response.id).update({'avatar': avatarUrl});
      }
    }

    loading = false;
    notifyListeners();
    return true;
  }
}
