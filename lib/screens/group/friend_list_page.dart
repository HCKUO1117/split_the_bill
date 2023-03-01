import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/providers/home_provider.dart';
import 'package:split_the_bill/screens/group/add_friend_page.dart';
import 'package:split_the_bill/screens/home_screen.dart';
import 'package:split_the_bill/widgets/friend_title.dart';

class FriendListPage extends StatefulWidget {
  final List<UserModel> addedList;
  const FriendListPage({Key? key, required this.addedList}) : super(key: key);

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<UserModel> selectedList = [];

  @override
  void initState() {
    selectedList = widget.addedList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = HomePage.navigatorKey.currentContext!.read<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).friends),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddFriendPage(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return CheckboxListTile(
            value: selectedList
                    .indexWhere((element) => element.uid == homeProvider.friends[index].uid) !=
                -1,
            onChanged: (value) {
              if (value == true) {
                selectedList.add(homeProvider.friends[index]);
              } else {
                selectedList
                    .removeWhere((element) => element.uid == homeProvider.friends[index].uid);
              }
              setState(() {});
            },
            subtitle: FriendTitle(
              model: homeProvider.friends[index],
              isFriend: true,
            ),
          );
        },
        itemCount: homeProvider.friends.length,
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            fixedSize: const Size(double.maxFinite, kBottomNavigationBarHeight),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          Navigator.pop(context, selectedList);
        },
        child: Text(S.of(context).confirm),
      ),
    );
  }
}
