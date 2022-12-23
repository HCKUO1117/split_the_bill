import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/user_provider.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({Key? key}) : super(key: key);

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(tag: 'createAccount', child: Consumer<UserProvider>(
      builder: (BuildContext context, UserProvider provider, _) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black54),
            title: Text(S.of(context).createAccount),
          ),
        );
      },
    ),);
  }
}
