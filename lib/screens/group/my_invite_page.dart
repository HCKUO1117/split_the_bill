import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/home_provider.dart';
import 'package:split_the_bill/utils/show_snack.dart';
import 'package:split_the_bill/widgets/custom_dialog.dart';
import 'package:split_the_bill/widgets/friend_title.dart';
import 'package:split_the_bill/widgets/loading_cover.dart';

class MyInvitePage extends StatefulWidget {
  const MyInvitePage({Key? key}) : super(key: key);

  @override
  State<MyInvitePage> createState() => _MyInvitePageState();
}

class _MyInvitePageState extends State<MyInvitePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (BuildContext context, HomeProvider provider, _) {
      return LoadingCover(
        loading: provider.loading,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).invite),
          ),
          body: provider.beInvitedList.isEmpty
              ? Center(
                  child: Text(S.of(context).noInvite),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FriendTitle(
                      model: provider.beInvitedList[index],
                      action: Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              bool? success = await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CustomDialog(content: S.of(context).denyInviteInfo));
                              if (success == true) {
                                provider.denyInvite(
                                  provider.beInvitedList[index].uid,
                                  onSuccess: () async {
                                    ShowSnack.show(context,
                                        content: S.of(context).denyInviteSuccess);
                                  },
                                  onError: (e) {
                                    ShowSnack.show(context,
                                        content: S.of(context).error + ' : ' + e);
                                  },
                                );
                              }
                            },
                            child: Text(
                              S.of(context).deny,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              bool? success = await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      CustomDialog(content: S.of(context).acceptInviteInfo));
                              if (success == true) {
                                provider.acceptInvite(
                                  provider.beInvitedList[index].uid,
                                  onSuccess: () async {
                                    ShowSnack.show(context,
                                        content: S.of(context).addFriendSuccess);
                                  },
                                  onError: (e) {
                                    ShowSnack.show(context,
                                        content: S.of(context).error + ' : ' + e);
                                  },
                                );
                              }
                            },
                            child: Text(
                              S.of(context).accept,
                              style: const TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      isFriend: context
                          .read<HomeProvider>()
                          .friends
                          .indexWhere((element) =>
                      provider.beInvitedList[index].uid ==
                          element.uid) !=
                          -1,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 8);
                  },
                  itemCount: provider.beInvitedList.length,
                ),
        ),
      );
    });
  }
}
