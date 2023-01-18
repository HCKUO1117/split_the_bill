import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_the_bill/generated/l10n.dart';
import 'package:split_the_bill/providers/add_friend_provider.dart';
import 'package:split_the_bill/widgets/friend_title.dart';
import 'package:split_the_bill/widgets/loading_widget.dart';
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
                      ))
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
                              child: provider.results.isEmpty
                                  ? Center(
                                      child: Text(S.of(context).noResult),
                                    )
                                  : ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return FriendTitle(model: provider.results[index]);
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
          );
        },
      ),
    );
  }
}
