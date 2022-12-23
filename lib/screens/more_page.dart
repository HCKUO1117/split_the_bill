import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Constants.more,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black54),
          title: Text(S.of(context).more),
        ),
      ),
    );
  }
}
