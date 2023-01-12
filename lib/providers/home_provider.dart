import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class HomeProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Reference storageRef = FirebaseStorage.instance.ref();

  HomeProvider() {
    String uid = Preferences.getString(Constants.uid, '');
    fireStore
        .collection('users')
        .doc(uid)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {});
    fireStore.collection('groups').snapshots(includeMetadataChanges: true).listen((event) {});
  }
}
