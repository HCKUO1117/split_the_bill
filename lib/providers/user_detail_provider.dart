import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class UserDetailProvider with ChangeNotifier {
  bool loading = false;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserModel userModel = UserModel();

  UserDetailProvider({required this.userModel}) {
    fireStore.collection('users').doc(userModel.uid).snapshots().listen((event) async {
      if (event.exists) {
        final data = event.data() as Map<String, dynamic>;
        userModel.name = data['name'];
        userModel.intro = data['intro'];
        userModel.avatar = data['avatar'];
        userModel.background = data['background'];
        notifyListeners();
      }
    });
  }

  Future<void> removeFriend({
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    final userFriendRef = fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('friends')
        .doc(userModel.uid);
    final targetFriendRef = fireStore
        .collection('users')
        .doc(userModel.uid)
        .collection('friends')
        .doc(Preferences.getString(Constants.uid, ''));
    final chatRef = fireStore
        .collection('chats')
        .doc(userModel.chatId);
    fireStore.runTransaction(
      (transaction) async {
        transaction.delete(userFriendRef);
        transaction.delete(targetFriendRef);
        transaction.delete(chatRef);
      },
    ).then((value) {
      loading = false;
      notifyListeners();
      onSuccess.call();
    }, onError: (e) {
      loading = false;
      notifyListeners();
      onError.call(e.toString());
    });
  }
}
