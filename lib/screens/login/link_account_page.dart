import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/widgets/google_sign_in_button.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({Key? key}) : super(key: key);

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends State<LinkAccountPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordSecond = TextEditingController();

  FocusNode passwordNode = FocusNode();
  FocusNode passwordSecondNode = FocusNode();

  String? emailError;
  String? passwordError;
  String? passwordSecondError;

  bool signUpIng = false;

  String? googleError;

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
    return Hero(
      tag: 'createAccount',
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black54),
                title: Text(S.of(context).createAccount),
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.black54,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(S.of(context).or),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          color: Colors.black54,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: GoogleSignInButton(
                      signInClick: () async {
                        setState(() {
                          signUpIng = true;
                        });
                        String? error = await provider.linkAnonymousAccount(LoginType.google);
                        if (error != null) {
                          setState(() {
                            debugPrint(error);
                            switch (error) {
                              case "provider-already-linked":
                              case "invalid-credential":
                              case "credential-already-in-use":
                              case "email-already-in-use":
                                googleError = S.of(context).emailUsed;
                                break;
                              case 'weak-password':
                                passwordError = S.of(context).passwordWeak;
                                break;
                              default:
                                googleError = error;
                            }
                          });
                        } else {
                          Navigator.pop(context, LoginType.google.name);
                        }
                        setState(() {
                          signUpIng = false;
                        });
                      },
                      isSigningIn: signUpIng,
                    ),
                  ),
                  if (googleError != null) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        googleError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget signUpButton(UserProvider provider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () async {
        if (signUpIng) return;
        setState(() {
          signUpIng = true;
        });
        if (password.text != passwordSecond.text) {
          setState(() {
            passwordSecondError = S.of(context).passwordNotMatch;
            signUpIng = false;
          });
          return;
        }
        String? error = await provider.linkAnonymousAccount(LoginType.email,
            email: email.text, password: password.text);
        if (error != null) {
          setState(() {
            debugPrint(error);
            switch (error) {
              case "provider-already-linked":
              case "invalid-credential":
              case "credential-already-in-use":
              case "email-already-in-use":
                emailError = S.of(context).emailUsed;
                break;
              case 'weak-password':
                passwordError = S.of(context).passwordWeak;
                break;
              default:
                emailError = error;
            }
          });
        } else {
          Navigator.pop(context, LoginType.email.name);
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
