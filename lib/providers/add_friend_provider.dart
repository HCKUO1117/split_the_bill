import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class AddFriendProvider with ChangeNotifier {
  bool searching = false;
  bool inviting = false;
  bool searched = false;
  TextEditingController search = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List<UserModel> results = [];

  Future<void> onSearch() async {
    searching = true;
    notifyListeners();
    fireStore.collection('users').where('email', isEqualTo: search.text).get().then(
      (value) {
        results.clear();
        for (var element in value.docs) {
          Map<String, dynamic> data = element.data();
          UserModel user = UserModel();
          user.uid = element.id;
          user.avatar = data['avatar'] ?? '';
          user.name = data['name'] ?? '';
          user.email = data['email'] ?? '';
          user.intro = data['intro'] ?? '';
          user.background = data['background'] ?? '';
          results.add(user);
        }
        searching = false;
        searched = true;
        notifyListeners();
      },
    );
  }

  Future<void> invite(
    String uid, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    inviting = true;
    notifyListeners();
    final userRef = fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('inviting')
        .doc(uid);
    final targetRef = fireStore
        .collection('users')
        .doc(uid)
        .collection('beInvited')
        .doc(Preferences.getString(Constants.uid, ''));
    fireStore.runTransaction(
      (transaction) async {
        transaction.set(userRef, {'1': 1});
        transaction.set(targetRef, {'1': 1});
      },
    ).then((value) {
      inviting = false;
      searched = false;
      results.clear();
      search.
      notifyListeners();
      onSuccess.call();
    }, onError: (e) {
      onError.call(e.toString());
    });
  }
}
