import 'package:flutter/material.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/widgets/profile_photo.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel userModel;

  const UserDetailPage({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.userModel.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ProfilePhoto(
                background: widget.userModel.background,
                profile: widget.userModel.avatar,
              ),
              const SizedBox(height: 16),
              Text(
                widget.userModel.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse('mailto:${widget.userModel.email}'));
                },
                child: Text(
                  widget.userModel.email,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(widget.userModel.intro),
            ],
          ),
        ),
      ),
    );
  }
}
