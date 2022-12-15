import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'addEvent',
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          iconTheme: const IconThemeData(color: Colors.black54),
          titleTextStyle: const TextStyle(color: Colors.black54),
          title: Text(S.of(context).addEvent),
        ),
      ),
    );
  }
}
