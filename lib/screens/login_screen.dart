import 'package:flutter/material.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/widgets/google_sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          children: [
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).login,
                  style: TextStyle(
                    fontFamily: Constants.roboto,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
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
                  outlineTextField(iconData: Icons.email_outlined),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).password,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  outlineTextField(
                    iconData: Icons.vpn_key_outlined,
                    obscure: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: loginButton(),
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
                    onTap: () {},
                    child: Text(
                      S.of(context).signUp,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
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
      ),
    );
  }

  Widget outlineTextField({IconData? iconData, bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: iconData != null ? Icon(iconData) : null,
        contentPadding: const EdgeInsets.all(4),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {},
      child: Text(S.of(context).login),
    );
  }
}
