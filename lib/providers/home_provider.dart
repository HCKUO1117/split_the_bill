import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class HomeProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Reference storageRef = FirebaseStorage.instance.ref();

  List<String> groupList = [];

  List<GroupModel> groups = [];

  HomeProvider() {
    String uid = Preferences.getString(Constants.uid, '');
    fireStore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      groupList.clear();
      for (var element in event.docs) {
        groupList.add(element.id);
      }
      notifyListeners();
    });
    fireStore.collection('groups').snapshots(includeMetadataChanges: true).listen((event) async {
      groups = [];
      print(event.docs);
      for (var element in event.docs) {
        print(element.id);
        Map<String, dynamic> data = element.data();
        List<String> member = [];
        await element.reference.collection('members').get().then((value) {
          for (var element in value.docs) {
            member.add(element.id);
          }
        });

        print(member);
        if (groupList.contains(element.id) && groups.indexWhere((e) => e.id == element.id) == -1) {
          groups.add(
            GroupModel(
              id: element.id,
              name: data['name'] ?? '',
              intro: data['intro'] ?? '',
              photo: data['avatar'] ?? '',
              host: data['admin'] ?? '',
              createAt: DateTime.fromMicrosecondsSinceEpoch(data['createAt'] ?? 0),
              members: member,
            ),
          );
        }
      }
      groups.toSet().toList();
      notifyListeners();
    });
  }
}
