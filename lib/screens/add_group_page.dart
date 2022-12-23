import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Constants.addGroup,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black54),
          title: Text(S.of(context).addGroup),
        ),
      ),
    );
  }
}
