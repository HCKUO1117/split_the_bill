import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          child: Column(
            children: [
              const SizedBox(height: 16),
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
}
