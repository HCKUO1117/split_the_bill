import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/utils/pick_image.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/loading_widget.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

import '../../generated/l10n.dart';

class PersonalEditPage extends StatefulWidget {
  const PersonalEditPage({Key? key}) : super(key: key);

  @override
  State<PersonalEditPage> createState() => _PersonalEditPageState();
}

class _PersonalEditPageState extends State<PersonalEditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController introController = TextEditingController();
  File? avatarPicked;
  File? backgroundPicked;

  bool loading = false;

  @override
  void initState() {
    UserProvider userProvider = context.read<UserProvider>();
    nameController.text = userProvider.user.name;
    introController.text = userProvider.user.intro;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userProvider, _) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(S.of(context).edit),
                ),
                body: ListView(
                  children: [
                    const SizedBox(height: 8),
                    editCard(
                      title: S.of(context).name,
                      update: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          loading = true;
                        });
                        userProvider.updateName(
                          name: nameController.text,
                          onSuccess: (_) {
                            userProvider.init();
                            ShowSnack.show(context, content: S.of(context).updateSuccess);
                            setState(() {
                              loading = false;
                            });
                          },
                          onError: (e) {
                            ShowSnack.show(context,
                                content: '${S.of(context).updateFail} : ${e.toString()}');
                            setState(() {
                              loading = false;
                            });
                          },
                          onTimeOut: () {
                            ShowSnack.show(context, content: S.of(context).timeOut);
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      },
                      shouldUpdate: nameController.text != userProvider.user.name,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: OutlineTextField(
                          controller: nameController,
                          onChange: (_) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    editCard(
                      title: S.of(context).intro,
                      shouldUpdate: introController.text != userProvider.user.intro,
                      update: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          loading = true;
                        });
                        userProvider.updateIntro(
                          intro: introController.text,
                          onSuccess: (_) {
                            userProvider.init();
                            ShowSnack.show(context, content: S.of(context).updateSuccess);
                            setState(() {
                              loading = false;
                            });
                          },
                          onError: (e) {
                            ShowSnack.show(context,
                                content: '${S.of(context).updateFail} : ${e.toString()}');
                            setState(() {
                              loading = false;
                            });
                          },
                          onTimeOut: () {
                            ShowSnack.show(context, content: S.of(context).timeOut);
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: OutlineTextField(
                          controller: introController,
                          onChange: (_) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    editCard(
                      title: S.of(context).profile,
                      shouldUpdate: avatarPicked != null,
                      update: () {
                        setState(() {
                          loading = true;
                        });
                        userProvider.updateAvatar(
                          avatar: avatarPicked!,
                          onSuccess: (_) {
                            userProvider.init();
                            ShowSnack.show(context, content: S.of(context).updateSuccess);
                            setState(() {
                              avatarPicked = null;
                              loading = false;
                            });
                          },
                          onError: (e) {
                            ShowSnack.show(context,
                                content: '${S.of(context).updateFail} : ${e.toString()}');
                            setState(() {
                              loading = false;
                            });
                          },
                          onTimeOut: () {
                            ShowSnack.show(context, content: S.of(context).timeOut);
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: avatarPicked != null
                                ? Image.file(
                                    avatarPicked!,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  )
                                : userProvider.user.photoUrl.isEmpty
                                    ? Image.asset(
                                        Constants.avatar,
                                        color: Colors.grey,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        userProvider.user.photoUrl,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) {
                                            return child;
                                          }
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey.shade100,
                                            child: Container(
                                              color: Colors.white,
                                              width: 150,
                                              height: 150,
                                            ),
                                          );
                                        },
                                      ),
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  XFile? image = await PickImage.pickFromCamera();
                                  if (image != null) {
                                    setState(() {
                                      avatarPicked = File(image.path);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                              IconButton(
                                onPressed: () async {
                                  XFile? image = await PickImage.pickFromGallery();
                                  if (image != null) {
                                    setState(() {
                                      avatarPicked = File(image.path);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.image_outlined),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    editCard(
                      title: S.of(context).background,
                      shouldUpdate: backgroundPicked != null,
                      update: () {
                        setState(() {
                          loading = true;
                        });
                        userProvider.updateBackground(
                          background: backgroundPicked!,
                          onSuccess: (_) {
                            userProvider.init();
                            ShowSnack.show(context, content: S.of(context).updateSuccess);
                            setState(() {
                              backgroundPicked = null;
                              loading = false;
                            });
                          },
                          onError: (e) {
                            ShowSnack.show(context,
                                content: '${S.of(context).updateFail} : ${e.toString()}');
                            setState(() {
                              loading = false;
                            });
                          },
                          onTimeOut: () {
                            ShowSnack.show(context, content: S.of(context).timeOut);
                            setState(() {
                              loading = false;
                            });
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: backgroundPicked != null
                                  ? Image.file(
                                      backgroundPicked!,
                                      fit: BoxFit.cover,
                                      height: (MediaQuery.of(context).size.width - 64) / 16 * 9,
                                      width: double.maxFinite,
                                    )
                                  : userProvider.user.backgroundImage.isEmpty
                                      ? Image.asset(
                                          Constants.background,
                                          height: (MediaQuery.of(context).size.width - 64) / 16 * 9,
                                          width: double.maxFinite,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          userProvider.user.backgroundImage,
                                          height: (MediaQuery.of(context).size.width - 64) / 16 * 9,
                                          width: double.maxFinite,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) {
                                              return child;
                                            }
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor: Colors.grey.shade100,
                                              child: Container(
                                                color: Colors.white,
                                                height: (MediaQuery.of(context).size.width - 64) /
                                                    16 *
                                                    9,
                                                width: double.maxFinite,
                                              ),
                                            );
                                          },
                                        ),
                            ),
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  XFile? image = await PickImage.pickFromCamera();
                                  if (image != null) {
                                    setState(() {
                                      backgroundPicked = File(image.path);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.camera_alt_outlined),
                              ),
                              IconButton(
                                onPressed: () async {
                                  XFile? image = await PickImage.pickFromGallery();
                                  if (image != null) {
                                    setState(() {
                                      backgroundPicked = File(image.path);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.image_outlined),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              if (loading) const LoadingWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget editCard({
    required String title,
    required Widget child,
    required bool shouldUpdate,
    required Function() update,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (shouldUpdate)
                    TextButton(
                      onPressed: update,
                      child: Text(S.of(context).update),
                    )
                ],
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
