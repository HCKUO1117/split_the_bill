import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/home_provider.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/chart/chart_page.dart';
import 'package:split_the_bill/screens/group/group_n_friend_page.dart';
import 'package:split_the_bill/screens/login/link_account_page.dart';
import 'package:split_the_bill/screens/login/login_screen.dart';
import 'package:split_the_bill/screens/person/personal_page.dart';
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
  int currentIndex = 0;

  late TabController tabController;

  HomeProvider homeProvider = HomeProvider();

  @override
  void initState() {
    context.read<UserProvider>().init();
    tabController = TabController(length: 3, vsync: this);
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: homeProvider),
      ],
      child: Consumer2<UserProvider, HomeProvider>(
        builder: (BuildContext context, UserProvider provider, HomeProvider homeProvider, _) {
          return Scaffold(
            appBar: currentIndex == 2
                ? null
                : AppBar(
                    // leading: Builder(
                    //   builder: (context) => IconButton(
                    //     onPressed: () {
                    //       Scaffold.of(context).openDrawer();
                    //     },
                    //     icon: const Icon(
                    //       Icons.person_outline,
                    //       color: Colors.black54,
                    //     ),
                    //   ),
                    // ),
                    actions: [
                      IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.black54,
                        ),
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: const [
                GroupNFriendPage(),
                ChartPage(),
                PersonalPage(),
              ],
            ),
            bottomNavigationBar: BottomBarInspiredFancy(
              items: [
                TabItem(icon: Icons.group, title: S.of(context).groups),
                TabItem(icon: Icons.bar_chart, title: S.of(context).statistics),
                TabItem(icon: Icons.account_circle, title: S.of(context).account),
              ],
              top: 16,
              colorSelected: Colors.blue,
              color: Colors.black54,
              indexSelected: currentIndex,
              backgroundColor: Colors.white,
             styleIconFooter: StyleIconFooter.dot,
              onTap: (index) {
                tabController.animateTo(index);
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }
}
