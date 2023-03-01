import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/preferences.dart';

class HomeProvider with ChangeNotifier {
  bool loading = false;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Reference storageRef = FirebaseStorage.instance.ref();

  List<String> groupList = [];

  List<GroupModel> groups = [];

  List<UserModel> friends = [];

  List<UserModel> invitingList = [];

  List<UserModel> beInvitedList = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? groupSubscribe;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? friendSubscribe;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? invitingSubscribe;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? beInvitedSubscribe;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? bigGroupSubscribe;

  HomeProvider() {
    String uid = Preferences.getString(Constants.uid, '');
    groupSubscribe = fireStore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .snapshots(includeMetadataChanges: true)
        .listen((event) async {
      groupList.clear();
      for (var element in event.docs) {
        groupList.add(element.id);
      }
      var groupRef = await fireStore.collection('groups').get();
      groups = [];
      for (var element in groupRef.docs) {
        if (groupList.contains(element.id) &&
            groups.indexWhere((e) => e.id == element.id) == -1) {
          Map<String, dynamic> data = element.data();
          List<String> member = [];
          await element.reference.collection('members').get().then((value) {
            for (var element in value.docs) {
              member.add(element.id);
            }
          });
          if (groups.indexWhere((e) => e.id == element.id) == -1) {
            groups.add(
              GroupModel(
                id: element.id,
                name: data['name'] ?? '',
                intro: data['intro'] ?? '',
                photo: data['avatar'] ?? '',
                host: data['admin'] ?? '',
                createAt:
                    DateTime.fromMicrosecondsSinceEpoch(data['createAt'] ?? 0),
                members: member,
              ),
            );
          }
        }
      }
      groups.toSet().toList();
      notifyListeners();
    });
    friendSubscribe = fireStore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      friends.clear();
      for (var element in event.docs) {
        fireStore.collection('users').doc(element.id).get().then((value) {
          if (value.exists) {
            final model = UserModel();
            Map<String, dynamic> data = value.data() as Map<String, dynamic>;
            model.uid = element.id;
            model.name = data['name'];
            model.avatar = data['avatar'];
            model.email = data['email'];
            model.background = data['background'];
            model.intro = data['intro'];
            model.chatId = element.data()['chat'];
            if (friends.indexWhere((e) => e.uid == element.id) == -1) {
              friends.add(model);
            }
            // invitingList.toSet().toList();
            notifyListeners();
          }
        });
      }
      notifyListeners();
    });
    invitingSubscribe = fireStore
        .collection('users')
        .doc(uid)
        .collection('inviting')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      invitingList.clear();
      for (var element in event.docs) {
        fireStore.collection('users').doc(element.id).get().then((value) {
          if (value.exists) {
            final model = UserModel();
            Map<String, dynamic> data = value.data() as Map<String, dynamic>;
            model.uid = element.id;
            model.name = data['name'];
            model.avatar = data['avatar'];
            model.email = data['email'];
            model.background = data['background'];
            model.intro = data['intro'];
            if (invitingList.indexWhere((e) => e.uid == element.id) == -1) {
              invitingList.add(model);
            }
            // invitingList.toSet().toList();
            notifyListeners();
          }
        });
      }
      notifyListeners();
    });
    beInvitedSubscribe = fireStore
        .collection('users')
        .doc(uid)
        .collection('beInvited')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      beInvitedList.clear();
      for (var element in event.docs) {
        fireStore.collection('users').doc(element.id).get().then((value) {
          if (value.exists) {
            final model = UserModel();
            Map<String, dynamic> data = value.data() as Map<String, dynamic>;
            model.uid = element.id;
            model.name = data['name'];
            model.avatar = data['avatar'];
            model.email = data['email'];
            model.background = data['background'];
            model.intro = data['intro'];
            if (beInvitedList.indexWhere((e) => e.uid == element.id) == -1) {
              beInvitedList.add(model);
            }
            // invitingList.toSet().toList();
            notifyListeners();
          }
        });
      }
      notifyListeners();
    });
    bigGroupSubscribe = fireStore
        .collection('groups')
        .snapshots(includeMetadataChanges: true)
        .listen((event) async {
      groups = [];
      for (var element in event.docs) {
        if (groupList.contains(element.id) &&
            groups.indexWhere((e) => e.id == element.id) == -1) {
          Map<String, dynamic> data = element.data();
          List<String> member = [];
          await element.reference.collection('members').get().then((value) {
            for (var element in value.docs) {
              member.add(element.id);
            }
          });

          if (groups.indexWhere((e) => e.id == element.id) == -1) {
            groups.add(
              GroupModel(
                id: element.id,
                name: data['name'] ?? '',
                intro: data['intro'] ?? '',
                photo: data['avatar'] ?? '',
                host: data['admin'] ?? '',
                createAt:
                    DateTime.fromMicrosecondsSinceEpoch(data['createAt'] ?? 0),
                members: member,
              ),
            );
          }
        }
      }
      groups.toSet().toList();
      notifyListeners();
    });
  }

  Future<void> cancelInvite(
    String uid, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    loading = true;
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
        transaction.delete(userRef);
        transaction.delete(targetRef);
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

  Future<void> denyInvite(
    String uid, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    loading = true;
    notifyListeners();
    final userRef = fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('beInvited')
        .doc(uid);
    final targetRef = fireStore
        .collection('users')
        .doc(uid)
        .collection('inviting')
        .doc(Preferences.getString(Constants.uid, ''));
    fireStore.runTransaction(
      (transaction) async {
        transaction.delete(userRef);
        transaction.delete(targetRef);
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

  Future<void> acceptInvite(
    String uid, {
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    loading = true;
    notifyListeners();
    final userRef = fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('beInvited')
        .doc(uid);
    final userFriendRef = fireStore
        .collection('users')
        .doc(Preferences.getString(Constants.uid, ''))
        .collection('friends')
        .doc(uid);
    final targetRef = fireStore
        .collection('users')
        .doc(uid)
        .collection('inviting')
        .doc(Preferences.getString(Constants.uid, ''));
    final targetFriendRef = fireStore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(Preferences.getString(Constants.uid, ''));
    final chatRef = fireStore.collection('chats');

    fireStore.runTransaction(
      (transaction) async {
        ///聊天室用套件做
        // var result = await chatRef.add({'lastMessage': '', 'lastSender': '', 'lastSendTime': 0});
        // chatRef
        //     .doc(result.id)
        //     .collection('users')
        //     .doc(Preferences.getString(Constants.uid, ''))
        //     .set({'read': true});
        // chatRef.doc(result.id).collection('users').doc(uid).set({'read': true});
        var room = await FirebaseChatCore.instance.createRoom(User(id: uid));
        transaction.delete(userRef);
        transaction.delete(targetRef);
        transaction.set(userFriendRef, {'chat': room.id});
        transaction.set(targetFriendRef, {'chat': room.id});
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

  @override
  void dispose() {
    groupSubscribe?.cancel();
    friendSubscribe?.cancel();
    invitingSubscribe?.cancel();
    beInvitedSubscribe?.cancel();
    bigGroupSubscribe?.cancel();
    super.dispose();
  }
}
