import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Constants.addEvent,
      child: Scaffold(
        appBar: AppBar(

          iconTheme: const IconThemeData(color: Colors.black54),
          title: Text(S.of(context).addEvent),
        ),
      ),
    );
  }
}
