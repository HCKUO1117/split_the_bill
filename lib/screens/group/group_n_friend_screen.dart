import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/group_model.dart';
import 'package:split_the_bill/providers/home_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/group/add_friend_page.dart';
import 'package:split_the_bill/screens/group/add_group_page.dart';
import 'package:split_the_bill/screens/group/group_page.dart';
import 'package:split_the_bill/screens/group/my_invite_page.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/custom_dialog.dart';
import 'package:split_the_bill/widgets/friend_title.dart';

class GroupNFriendScreen extends StatefulWidget {
  const GroupNFriendScreen({Key? key}) : super(key: key);

  @override
  State<GroupNFriendScreen> createState() => _GroupNFriendScreenState();
}

class _GroupNFriendScreenState extends State<GroupNFriendScreen> with TickerProviderStateMixin {
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
            iconTitle(
              icon: Icons.person_add_alt_1,
              title: S.of(context).addFriend,
              onTap: () async {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: provider,
                      child: const AddFriendPage(),
                    ),
                  ),
                );
              },
            ),
            iconTitle(
              icon: Icons.group_add,
              title: S.of(context).addGroup,
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
            iconTitle(
              icon: Icons.emoji_people_outlined,
              title: S.of(context).invite,
              action: Text('( ${provider.beInvitedList.length} )'),
              onTap: () async {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: provider,
                      child: const MyInvitePage(),
                    ),
                  ),
                );
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
                    S.of(context).groups + ' (${provider.groups.length})',
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
                    S.of(context).friends +
                        ' (${provider.invitingList.length + provider.friends.length})',
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
              child: friends(provider),
            ),
          ],
        );
      },
    );
  }

  Widget groups(HomeProvider provider) {
    if (provider.groups.isEmpty) {
      return const SizedBox();
    }
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

  Widget friends(HomeProvider provider) {
    return Column(
      children: [
        if (provider.invitingList.isNotEmpty)
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FriendTitle(
                model: provider.invitingList[index],
                action: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  onSelected: (i) async {
                    if (i == 1) {
                      bool? check = await showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          content: S.of(context).cancelInviteInfo,
                        ),
                      );
                      if (check == true) {
                        provider.cancelInvite(
                          provider.invitingList[index].uid,
                          onSuccess: () {
                            ShowSnack.show(context, content: S.of(context).cancelInviteSuccess);
                          },
                          onError: (e) {
                            ShowSnack.show(context, content: S.of(context).cancelInviteFail);
                          },
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [const PopupMenuItem(value: 1, child: Text('取消邀請'))];
                  },
                  child: Text(S.of(context).inviting),
                ),
                isFriend: context
                        .read<HomeProvider>()
                        .friends
                        .indexWhere((element) => provider.invitingList[index].uid == element.uid) !=
                    -1,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: provider.invitingList.length,
          ),
        if (provider.friends.isNotEmpty)
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FriendTitle(
                model: provider.friends[index],
                isFriend: context
                        .read<HomeProvider>()
                        .friends
                        .indexWhere((element) => provider.friends[index].uid == element.uid) !=
                    -1,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemCount: provider.friends.length,
          ),
      ],
    );
  }

  Widget groupTitle(GroupModel model) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GroupPage(model: model),
          ),
        );
      },
      child: Row(
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
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(model.name + ' (${model.members.length}) '))
        ],
      ),
    );
  }

  Widget iconTitle({
    required IconData icon,
    required String title,
    required Function() onTap,
    Widget? action,
  }) {
    return InkWell(
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
            const Spacer(),
            if (action != null) ...[
              action,
              const SizedBox(width: 16),
            ]
          ],
        ),
      ),
    );
  }
}
