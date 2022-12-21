import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/forget_password_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController email = TextEditingController();

  final ForgetPasswordProvider userProvider = ForgetPasswordProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider.value(
        value: userProvider,
        child: Consumer<ForgetPasswordProvider>(
          builder: (BuildContext context, ForgetPasswordProvider provider, _) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black54),
                title: Text(
                  S.of(context).forgetPassword,
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
                          S.of(context).sendResetEmailInfo,
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
                          errorText: provider.errorText,
                          onChange: (_) {
                            setState(() {
                              provider.errorText = null;
                            });
                          },
                          onSubmit: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: sendButton(provider),
                        ),
                        const SizedBox(height: 32),
                        if (provider.status == ForgetPasswordStatus.isSend)
                          Text(
                            S.of(context).notGetMailInfo,
                            style: const TextStyle(color: Colors.black54),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget sendButton(ForgetPasswordProvider provider) {
    Widget child() {
      switch (provider.status) {
        case ForgetPasswordStatus.unSend:
          return Text(S.of(context).send);
        case ForgetPasswordStatus.sending:
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        case ForgetPasswordStatus.isSend:
          return Text(S.of(context).resend);
      }
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        provider.resetPassword(context, email: email.text);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 42,
        child: Center(
          child: child(),
        ),
      ),
    );
  }
}
