import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/add_friend_provider.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class AddRobotPage extends StatefulWidget {
  const AddRobotPage({Key? key}) : super(key: key);

  @override
  State<AddRobotPage> createState() => _AddRobotPageState();
}

class _AddRobotPageState extends State<AddRobotPage> {
  TextEditingController name = TextEditingController();
  TextEditingController intro = TextEditingController();

  FocusNode nameNode = FocusNode();
  FocusNode introNode = FocusNode();

  String? nameError;

  @override
  void dispose() {
    name.dispose();
    intro.dispose();

    nameNode.dispose();
    introNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, AddFriendProvider provider, _) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).addRobot),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    const Icon(Icons.smart_toy_outlined),
                    const SizedBox(width: 8),
                    Text(S.of(context).name)
                  ],
                ),
                const SizedBox(height: 8),
                OutlineTextField(
                  controller: name,
                  focusNode: nameNode,
                  errorText: nameError,
                  textInputAction: TextInputAction.next,
                  onSubmit: (v) {
                    FocusScope.of(context).requestFocus(introNode);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.smart_toy_outlined),
                    const SizedBox(width: 8),
                    Text(S.of(context).intro)
                  ],
                ),
                const SizedBox(height: 8),
                OutlineTextField(
                  controller: intro,
                  focusNode: introNode,
                  minLine: 5,
                ),
              ],
            ),
            bottomNavigationBar: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: const Size(double.maxFinite, kBottomNavigationBarHeight),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              onPressed: () async {
                setState(() {
                  nameError = null;
                });
                if (name.text.isEmpty) {
                  setState(() {
                    nameError = S.of(context).nameNotFill;
                  });
                  ShowSnack.show(
                    context,
                    content: S.of(context).nameNotFill,
                  );
                  return;
                }
                provider.addRobot(
                  name.text,
                  intro.text,
                  onSuccess: () {
                    ShowSnack.show(context, content: S.of(context).addRobotSuccess);
                    Navigator.pop(context);
                  },
                  onError: (e) {
                    ShowSnack.show(context, content: S.of(context).error + e);
                  },
                );
              },
              child: Text(S.of(context).create),
            ),
          ),
        );
      },
    );
  }
}
