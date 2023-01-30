import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/login/link_account_page.dart';
import 'package:split_the_bill/screens/login/login_screen.dart';
import 'package:split_the_bill/screens/person/personal_edit_page.dart';
import 'package:split_the_bill/utils/preferences.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/icon_title.dart';
import 'package:split_the_bill/widgets/profile_photo.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userProvider, _) {
          return ListView(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProfilePhoto(
                  background: userProvider.user.background,
                  profile: userProvider.user.avatar,
                ),
              ),
              Text(userProvider.user.name),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () async {
                      bool? success = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalEditPage(),
                        ),
                      );
                      if (success == true) {
                        ShowSnack.show(context, content: S.of(context).updateSuccess);
                      }
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              if (Preferences.getString(Constants.loginType, '') == LoginType.anonymous.name)
                IconTitle(
                  icon: Icons.link,
                  title: S.of(context).createAccount,
                  onTap: () async {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    String? type = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LinkAccountPage(),
                      ),
                    );
                    if (type == LoginType.email.name) {
                      Navigator.pop(context);
                      await Preferences.setString(Constants.loginType, LoginType.email.name);
                      ShowSnack.show(
                        context,
                        content: S.of(context).createAccountSuccess,
                      );
                    }
                    if (type == LoginType.google.name) {
                      Navigator.pop(context);
                      await Preferences.setString(Constants.loginType, LoginType.email.name);
                      ShowSnack.show(
                        context,
                        content: S.of(context).createAccountSuccess,
                      );
                    }
                    setState(() {});
                  },
                ),
              IconTitle(
                icon: Icons.logout,
                title: S.of(context).logout,
                onTap: () async {
                  await userProvider.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  ShowSnack.show(context, content: S.of(context).logoutSuccess);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
