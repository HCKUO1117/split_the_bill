import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/add_group_page.dart';
import 'package:split_the_bill/screens/add_member_page.dart';
import 'package:split_the_bill/screens/login/link_account_page.dart';
import 'package:split_the_bill/screens/login/login_screen.dart';
import 'package:split_the_bill/screens/more_page.dart';
import 'package:split_the_bill/utils/preferences.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/custom_dialog.dart';

class HomePage extends StatefulWidget {
  final bool firstAnonymous;

  const HomePage({Key? key, this.firstAnonymous = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.firstAnonymous) {
        showDialog(
          context: context,
          builder: (context) => CustomDialog(content: S.of(context).anonymouslyLoginInfo),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (BuildContext context, UserProvider provider, _) {
      return Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.person_outline,
                color: Colors.black54,
              ),
            ),
          ),
          actions: [
            Hero(
              tag: Constants.more,
              child: Material(
                color: Colors.white,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MorePage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
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
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddGroupPage(),
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
                    S.of(context).groups + ' (0)',
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
              child: const Center(
                child: FlutterLogo(size: 200.0),
              ),
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
                    S.of(context).members + ' (0)',
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
        ),
        drawer: SafeArea(
          child: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: ListView(
              children: [
                if (Preferences.getString(Constants.loginType, '') == LoginType.anonymous.name)
                  iconTitle(
                    icon: Icons.link,
                    title: S.of(context).createAccount,
                    onTap: () async {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      String? type = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LinkAccountPage(),
                        ),
                      );
                      if (type == LoginType.email.name) {
                        Navigator.pop(context);
                        await Preferences.setString(Constants.loginType, LoginType.email.name);
                        ShowSnack.show(
                          context,
                          content: S.of(context).createAccountSuccess,
                        );
                      }
                      if (type == LoginType.google.name) {
                        Navigator.pop(context);
                        await Preferences.setString(Constants.loginType, LoginType.email.name);
                        ShowSnack.show(
                          context,
                          content: S.of(context).createAccountSuccess,
                        );
                      }
                      setState(() {});
                    },
                    heroTag: 'createAccount',
                  ),
                iconTitle(
                  icon: Icons.logout,
                  title: S.of(context).logout,
                  onTap: () async {
                    await provider.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    ShowSnack.show(context, content: S.of(context).logoutSuccess);
                  },
                  heroTag: 'logout',
                ),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton(
        //   heroTag: Constants.addEvent,
        //   backgroundColor: Colors.white,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       side: const BorderSide(color: Colors.black54, width: 1.5)),
        //   onPressed: () {
        //     Navigator.of(context).push(
        //       MaterialPageRoute(
        //         builder: (context) => const AddEventPage(),
        //       ),
        //     );
        //   },
        //   tooltip: 'Increment',
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.black54,
        //   ),
        // ),
      );
    });
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
