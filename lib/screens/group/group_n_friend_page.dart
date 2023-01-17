import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/providers/home_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/group/add_group_page.dart';
import 'package:split_the_bill/screens/group/add_member_page.dart';
import 'package:split_the_bill/utils/show_snack.dart';

class GroupNFriendPage extends StatefulWidget {
  const GroupNFriendPage({Key? key}) : super(key: key);

  @override
  State<GroupNFriendPage> createState() => _GroupNFriendPageState();
}

class _GroupNFriendPageState extends State<GroupNFriendPage> with TickerProviderStateMixin {
  late final AnimationController memberController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> memberAnimation = CurvedAnimation(
    parent: memberController,
    curve: Curves.fastOutSlowIn,
  );
  bool memberExpand = true;

  late final AnimationController groupController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
  );
  late final Animation<double> groupAnimation = CurvedAnimation(
    parent: groupController,
    curve: Curves.fastOutSlowIn,
  );

  bool groupExpand = true;

  @override
  void initState() {
    groupController.forward();
    memberController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (BuildContext context, HomeProvider provider, _) {
        return ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       S.of(context).members,
            //       style: Constants.robotoTextStyle.copyWith(
            //         color: Colors.black54,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     )
            //   ],
            // ),
            // const Divider(),
            iconTitle(
              icon: Icons.person_add_alt,
              title: S.of(context).addMember,
              heroTag: Constants.addMember,
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMemberPage(),
                  ),
                );
              },
            ),
            iconTitle(
              icon: Icons.group_add_outlined,
              title: S.of(context).addGroup,
              heroTag: Constants.addGroup,
              onTap: () async {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                bool? success = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddGroupPage(),
                  ),
                );
                if (success == true) {
                  ShowSnack.show(context, content: S.of(context).createSuccess);
                }
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                if (groupExpand) {
                  groupController.reverse();
                  groupExpand = !groupExpand;
                } else {
                  groupController.forward();
                  groupExpand = !groupExpand;
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    S.of(context).groups + ' (${provider.groupList.length})',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: -0.5).animate(groupAnimation),
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: groupAnimation,
              axis: Axis.vertical,
              axisAlignment: -1,
              child: groups(provider),
            ),
            InkWell(
              onTap: () {
                if (memberExpand) {
                  memberController.reverse();
                  memberExpand = !memberExpand;
                } else {
                  memberController.forward();
                  memberExpand = !memberExpand;
                }
              },
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    S.of(context).friends + ' (0)',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      color: Colors.grey,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: -0.5).animate(memberAnimation),
                    child: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: memberAnimation,
              axis: Axis.vertical,
              axisAlignment: -1,
              child: const Center(
                child: FlutterLogo(size: 200.0),
              ),
            ),
          ],
        );
      },
    );
  }

  final Stream<QuerySnapshot> _groupsStream =
      FirebaseFirestore.instance.collection('groups').snapshots();

  Widget groups(HomeProvider provider) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return groupTitle(provider.groups[index]);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemCount: provider.groups.length,
    );
  }

  Widget groupTitle(GroupModel model) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: model.photo.isEmpty
              ? Image.asset(
                  Constants.background,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  model.photo,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(model.name + '(${model.members.length})'))
      ],
    );
  }

  Widget iconTitle({
    required IconData icon,
    required String title,
    required Function() onTap,
    required String heroTag,
  }) {
    return Hero(
      tag: heroTag,
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(icon),
                const SizedBox(width: 8),
                Text(title),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
