import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/providers/user_detail_provider.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/screens/chat_page.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/custom_dialog.dart';
import 'package:split_the_bill/widgets/profile_photo.dart';
import 'package:url_launcher/url_launcher.dart';

import 'flyer_chat_page.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel userModel;
  final bool isFriend;

  const UserDetailPage({
    Key? key,
    required this.userModel,
    required this.isFriend,
  }) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDetailProvider(
        userModel: widget.userModel,
      ),
      child: Consumer<UserDetailProvider>(
        builder: (BuildContext context, UserDetailProvider provider, _) {
          return SelectionArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(provider.userModel.name),
                actions: [
                  if (widget.isFriend)
                    PopupMenuButton(
                      position: PopupMenuPosition.under,
                      onSelected: (value) async {
                        if (value == 'remove') {
                          bool? success = await showDialog(
                            context: context,
                            builder: (context) =>
                                CustomDialog(content: S.of(context).removeFriendInfo),
                          );
                          if (success == true) {
                            provider.removeFriend(
                              onSuccess: () {
                                Navigator.pop(context, 'removed');
                                ShowSnack.show(context, content: S.of(context).removeFriendSuccess);
                              },
                              onError: (e) {
                                ShowSnack.show(context, content: S.of(context).error + ' : ' + e);
                              },
                            );
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'remove',
                          child: Text(
                            S.of(context).removeFriend,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ProfilePhoto(
                      background: provider.userModel.background,
                      profile: provider.userModel.avatar,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.userModel.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: provider.userModel.email)).then(
                          (value) => ShowSnack.show(context, content: S.of(context).emailCopied),
                        );
                      },
                      child: Text(
                        provider.userModel.email,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.userModel.intro,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                elevation: 2,
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {
                                launchUrl(Uri.parse('mailto:${provider.userModel.email}'));
                              },
                              child: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 8),
                            const Text('Email'),
                          ],
                        ),
                        if (widget.isFriend)
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  elevation: 2,
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                        height: MediaQuery.of(context).size.height * 0.85,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0),
                                          ),
                                        ),
                                        child: FlyChatPage(
                                          room: Room(
                                              id: provider.userModel.chatId,
                                              type: RoomType.direct,
                                              users: [
                                                User(
                                                  id: context.read<UserProvider>().user.uid,
                                                  firstName: context.read<UserProvider>().user.name,
                                                  imageUrl:
                                                      context.read<UserProvider>().user.avatar,
                                                ),
                                                User(
                                                  id: provider.userModel.uid,
                                                  firstName: provider.userModel.name,
                                                  imageUrl: provider.userModel.avatar,
                                                )
                                              ]),
                                        )
                                        // ChatPage(
                                        //   chatId: provider.userModel.chatId,
                                        //   users: [
                                        //     context.read<UserProvider>().user,
                                        //     provider.userModel,
                                        //   ],
                                        // ),
                                        ),
                                  );
                                },
                                child: const Icon(Icons.chat_bubble_outline),
                              ),
                              const SizedBox(height: 8),
                              Text(S.of(context).chat),
                            ],
                          ),
                        if (widget.isFriend)
                          Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  elevation: 2,
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {},
                                child: const Icon(Icons.list),
                              ),
                              const SizedBox(height: 8),
                              Text(S.of(context).accounting),
                            ],
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
