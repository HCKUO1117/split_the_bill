import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FocusNode passwordNode = FocusNode();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black54),
              title: Text(
                S.of(context).signUp,
                style: TextStyle(
                  fontFamily: Constants.roboto,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).signUpInfo,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).email,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      OutlineTextField(
                        controller: email,
                        iconData: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                        onSubmit: (_) {
                          FocusScope.of(context).requestFocus(passwordNode);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).password,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      OutlineTextField(
                        controller: password,
                        focusNode: passwordNode,
                        onSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        iconData: Icons.vpn_key_outlined,
                        obscure: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: signUpButton(provider),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget signUpButton(UserProvider provider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        provider.createPasswordAccount(email: email.text, password: password.text);
      },
      child: Text(S.of(context).signUp),
    );
  }
}
