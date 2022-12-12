import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.groups_outlined,
              color: Colors.black54,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [],
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
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
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).members,
                    style: Constants.robotoTextStyle.copyWith(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const Divider(),
              iconTitle(
                icon: Icons.person_add_alt,
                title: S.of(context).addMember,
                onTap: () {},
              ),
              iconTitle(
                icon: Icons.group_add_outlined,
                title: S.of(context).addGroup,
                onTap: () {},
              ),
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black54, width: 1.5)),
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget iconTitle({
    required IconData icon,
    required String title,
    required Function() onTap,
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
          ],
        ),
      ),
    );
  }
}
