import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/models/user_model.dart';

class AddFriendProvider with ChangeNotifier {
  bool searching = false;
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
        searching= false;
        notifyListeners();
      },
    );
  }
}
