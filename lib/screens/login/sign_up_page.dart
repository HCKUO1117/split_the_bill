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
  TextEditingController passwordSecond = TextEditingController();

  FocusNode passwordNode = FocusNode();
  FocusNode passwordSecondNode = FocusNode();

  String? emailError;
  String? passwordError;
  String? passwordSecondError;

  bool signUpIng = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordSecond.dispose();
    passwordNode.dispose();
    passwordSecondNode.dispose();
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
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      OutlineTextField(
                        controller: email,
                        iconData: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                        errorText: emailError,
                        onSubmit: (_) {
                          FocusScope.of(context).requestFocus(passwordNode);
                        },
                        onChange: (_) {
                          setState(() {
                            emailError = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).password,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      Text(
                        S.of(context).passwordInfo,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlineTextField(
                        controller: password,
                        focusNode: passwordNode,
                        errorText: passwordError,
                        textInputAction: TextInputAction.next,
                        onSubmit: (_) {
                          FocusScope.of(context).requestFocus(passwordSecondNode);
                        },
                        onChange: (_) {
                          setState(() {
                            passwordError = null;
                          });
                        },
                        iconData: Icons.vpn_key_outlined,
                        obscure: true,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).checkPassword,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      Text(
                        S.of(context).checkPasswordInfo,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlineTextField(
                        controller: passwordSecond,
                        focusNode: passwordSecondNode,
                        errorText: passwordSecondError,
                        onSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        onChange: (_) {
                          setState(() {
                            passwordSecondError = null;
                          });
                        },
                        iconData: Icons.vpn_key_outlined,
                        obscure: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Center(
                    child: signUpButton(provider),
                  ),
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
      onPressed: () async {
        if (signUpIng) return;
        setState(() {
          signUpIng = true;
        });
        if (password.text != passwordSecond.text) {
          setState(() {
            passwordSecondError = S.of(context).passwordNotMatch;
          });
          return;
        }
        String? error =
            await provider.createPasswordAccount(email: email.text, password: password.text);
        if (error != null) {
          setState(() {
            switch (error) {
              case 'weak-password':
                passwordError = S.of(context).passwordWeak;
                break;
              case 'email-already-in-use':
                emailError = S.of(context).emailUsed;
                break;
              default:
                emailError = error;
            }
          });
        }else{
          Navigator.pop(context,true);
        }

        setState(() {
          signUpIng = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 42,
        child: Center(
          child: signUpIng
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(S.of(context).signUp),
        ),
      ),
    );
  }
}
