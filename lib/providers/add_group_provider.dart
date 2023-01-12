import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class AddGroupProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  TextEditingController groupName = TextEditingController();

  String? error;

  List<MemberModel> members = [];

  void addMember(MemberModel memberModel) {
    members.add(memberModel);
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

  void removeMember(MemberModel memberModel) {
    members.removeWhere((element) => element.id == memberModel.id);
    notifyListeners();
  }

  Future<bool> addGroupToDataBase(BuildContext context) async {
    if (groupName.text.isEmpty) {
      error = S.of(context).nameNotFill;
      notifyListeners();
      return false;
    }

    var response = await fireStore.collection('groups').add({
      'name': groupName.text,
    });
    fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('groups')
        .doc(response.id)
        .set({});
    return true;
  }
}
