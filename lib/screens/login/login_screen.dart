import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/login/forget_password_page.dart';
import 'package:split_the_bill/screens/login/sign_up_page.dart';
import 'package:split_the_bill/widgets/google_sign_in_button.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              title: Text(
                S.of(context).login,
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
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  child: loginButton(provider),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Wrap(
                    children: [
                      Text(
                        S.of(context).noAccount + ' ? ',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        S.of(context).clickHere + ' ',
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          S.of(context).signUp,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      S.of(context).forgetPassword,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

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
                    signInClick: () {},
                    isSigningIn: false,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      S.of(context).guestLogin,
                      style: const TextStyle(
                        color: Colors.black54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget loginButton(UserProvider provider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        provider.loginByPassword(email: email.text, password: password.text);
      },
      child: Text(S.of(context).login),
    );
  }
}
