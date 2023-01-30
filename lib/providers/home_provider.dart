import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
    fireStore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      friends.clear();
      for (var element in event.docs) {}
      notifyListeners();
    });
    fireStore
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
    });
    fireStore
        .collection('users')
        .doc(uid)
        .collection('beInvited')
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      beInvitedList.clear();
      for (var element in event.docs) {}
      notifyListeners();
    });
    fireStore.collection('groups').snapshots(includeMetadataChanges: true).listen((event) async {
      groups = [];
      for (var element in event.docs) {
        Map<String, dynamic> data = element.data();
        List<String> member = [];
        await element.reference.collection('members').get().then((value) {
          for (var element in value.docs) {
            member.add(element.id);
          }
        });

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
      onError.call(e.toString());
    });
  }
}
