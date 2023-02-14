import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/models/chat_model.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatProvider with ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  Reference storageRef = FirebaseStorage.instance.ref();

  String chatId;


  ChatProvider({required this.chatId}) {
    getChatContents = fireStore
        .collection('chats')
        .doc(chatId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }

  TextEditingController input = TextEditingController();

  int limit = 50;

  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatContents;

  void loadMore() {
    limit += 50;
  }

  Future<void> sendMessage(BuildContext context,MessageType type) async {
    await fireStore
        .collection('chats')
        .doc(chatId)
        .collection('chats')
        .doc(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString())
        .set(
      {
        'message': input.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
        'sender': context
            .read<UserProvider>()
            .user
            .uid,
        'type': type.name,
      },
    );
    input.text = '';
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> createUser(BuildContext context) async {
    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: 'John',
        id: context
            .read<UserProvider>()
            .user
            .uid, // UID from Firebase Authentication
        imageUrl: 'https://i.pravatar.cc/300',
        lastName: 'Doe',
      ),
    );
  }
}
