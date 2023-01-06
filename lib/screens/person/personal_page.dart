import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/widgets/profile_photo.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ProfilePhoto(
              background: userProvider.user.backgroundImage,
              profile: userProvider.user.photoUrl,
            ),
          ),
          Text(userProvider.user.name),
        ],
      ),
    );
  }
}
