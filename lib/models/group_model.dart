import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum MemberRole {
  admin,
  editor,
  viewer,
}

class GroupModel with ChangeNotifier {
  String id;
  String name;
  String intro;
  String photo;
  String host;
  DateTime createAt;
  List<String> members;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  GroupModel({
    required this.id,
    required this.name,
    required this.intro,
    required this.photo,
    required this.host,
    required this.createAt,
    required this.members,
  }) {
    // fireStore.collection('groups').doc(id).collection('members').get().then(
    //   (value) {
    //     for (var element in value.docs) {
    //       members.add(element.id);
    //     }
    //     notifyListeners();
    //   },
    // );
  }
}

class MemberModel {
  String id;
  String name;
  String avatar;
  MemberRole role;
  bool joined;
  bool connected;

  MemberModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.joined,
    required this.connected,
  });
}
