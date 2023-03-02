import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/providers/add_friend_provider.dart';
import 'package:split_the_bill/providers/home_provider.dart';
import 'package:split_the_bill/providers/user_provider.dart';
import 'package:split_the_bill/screens/home_screen.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/friend_title.dart';
import 'package:split_the_bill/widgets/icon_title.dart';
import 'package:split_the_bill/widgets/loading_cover.dart';
import 'package:split_the_bill/widgets/outline_text_field.dart';

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({Key? key}) : super(key: key);

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  AddFriendProvider addFriendProvider = AddFriendProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: addFriendProvider,
      child: Consumer<AddFriendProvider>(
        builder: (BuildContext context, AddFriendProvider provider, _) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: LoadingCover(
              loading: provider.inviting,
              child: Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.black54),
                  title: Text(S.of(context).addFriend),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTitle(
                        icon: Icons.smart_toy_outlined,
                        title: S.of(context).addRobot,
                        onTap: () {},
                      ),
                      Text(
                        S.of(context).searchFriendInfo,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      OutlineTextField(
                        controller: provider.search,
                        textInputAction: TextInputAction.search,
                        textInputType: TextInputType.emailAddress,
                        onSubmit: (_) {
                          provider.onSearch();
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            provider.onSearch();
                          },
                          icon: const Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (provider.searching)
                        const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    S.of(context).results + ' (${provider.results.length}) ',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey,
                                      height: 1,
                                      width: double.maxFinite,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: !provider.searched
                                    ? const SizedBox()
                                    : provider.results.isEmpty
                                        ? Center(
                                            child: Text(S.of(context).noResult),
                                          )
                                        : ListView.separated(
                                            physics: const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return FriendTitle(
                                                model: provider.results[index],
                                                action: action(provider.results[index]),
                                                isFriend: HomePage.navigatorKey.currentContext!
                                                        .read<HomeProvider>()
                                                        .friends
                                                        .indexWhere((element) =>
                                                            provider.results[index].uid ==
                                                            element.uid) !=
                                                    -1,
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(height: 8);
                                            },
                                            itemCount: provider.results.length,
                                          ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget action(UserModel model) {
    UserProvider userProvider = context.read<UserProvider>();
    HomeProvider homeProvider = HomePage.navigatorKey.currentContext!.read<HomeProvider>();

    if (model.uid == userProvider.user.uid) {
      return Text(S.of(context).you);
    }
    if (homeProvider.friends.indexWhere((element) => element.uid == model.uid) != -1) {
      model.chatId = homeProvider.friends.firstWhere((element) => element.uid == model.uid).chatId;
      return Text(S.of(context).friends);
    }
    if (homeProvider.invitingList.indexWhere((element) => element.uid == model.uid) != -1) {
      return Text(S.of(context).inviting);
    }
    return TextButton(
      onPressed: () {
        addFriendProvider.invite(
          model.uid,
          onSuccess: () {
            ShowSnack.show(context, content: S.of(context).inviteSend);
          },
          onError: (e) {
            ShowSnack.show(context, content: S.of(context).error + ' : ' + e);
          },
        );
      },
      child: Text(S.of(context).invite),
    );
  }
}
