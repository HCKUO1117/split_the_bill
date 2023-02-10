import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:split_the_bill/models/user_model.dart';

class ChatProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserModel userModel;

  ChatProvider({required this.userModel}) {
    getChatContents = fireStore
        .collection('chat')
        .doc(userModel.chatId)
        .collection('chats')
        .orderBy('sendTime', descending: true)
        .limit(limit)
        .snapshots();
  }

  TextEditingController input = TextEditingController();

  int limit = 50;

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatContents;

  void loadMore() {
    limit += 50;
  }
}
