import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/add_group_provider.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/res/constants.dart';
import 'package:split_the_bill/screens/group/friend_list_page.dart';
import 'package:split_the_bill/utils/pick_image.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/friend_title.dart';
import 'package:split_the_bill/widgets/loading_cover.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  AddGroupProvider addGroupProvider = AddGroupProvider();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: ChangeNotifierProvider.value(
        value: addGroupProvider,
        child: Consumer<AddGroupProvider>(
          builder: (BuildContext context, AddGroupProvider provider, _) {
            return LoadingCover(
              loading: provider.loading,
              child: Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.black54),
                  title: Text(S.of(context).addGroup),
                ),
                body: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: provider.photo != null
                                  ? Image.file(
                                      provider.photo!,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      Constants.background,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                                child: GestureDetector(
                              onTap: () async {
                                XFile? image = await PickImage.pickFromGallery();
                                if (image != null) {
                                  setState(() {
                                    provider.photo = File(image.path);
                                  });
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.image_outlined),
                              ),
                            ))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(S.of(context).groupName),
                    const SizedBox(height: 8),
                    OutlineTextField(
                      controller: provider.groupName,
                      errorText: provider.error,
                      onChange: (_) {
                        setState(() {
                          provider.error = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(S.of(context).members),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 1,
                            width: double.maxFinite,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    FriendTitle(
                      model: userProvider.user,
                      isFriend: false,
                      you: true,
                    ),
                    for (var element in addGroupProvider.members)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: FriendTitle(
                          model: element,
                          isFriend: true,
                          action: IconButton(
                            onPressed: () {
                              addGroupProvider.removeMember(element);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FriendListPage(
                              addedList: addGroupProvider.members,
                            ),
                          ),
                        );
                        setState(() {
                          addGroupProvider.members = result;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
                bottomNavigationBar: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      fixedSize: const Size(double.maxFinite, kBottomNavigationBarHeight),
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  onPressed: () async {
                    bool success = await provider.addGroupToDataBase(
                      context,
                      onError: () {
                        ShowSnack.show(context, content: S.of(context).unknownError);
                      },
                    );
                    if (success) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text(S.of(context).create),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
