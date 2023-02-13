import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:split_the_bill/models/chat_model.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/providers/chat_provider.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatefulWidget {
  final String chatId;
  final List<UserModel> users;

  const ChatPage({
    Key? key,
    required this.chatId,
    required this.users,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatProvider chatProvider;

  @override
  void initState() {
    chatProvider = ChatProvider(chatId: widget.chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Center(
                    child: Text(
                      'Chat',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                )
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: chatProvider.getChatContents,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  List<ChatModel> list = [];
                  snapshot.data?.docs.forEach((element) {
                    MessageType type =
                        element.data()['type'] == 'text' ? MessageType.text : MessageType.image;
                    print(element.metadata.hasPendingWrites);
                    print(element.data()['message']);
                    list.add(
                      ChatModel(
                        message: element.data()['message'],
                        time: DateTime.fromMillisecondsSinceEpoch(element.data()['time']),
                        senderId: element.data()['sender'],
                        type: type,
                        cache: element.metadata.hasPendingWrites,
                      ),
                    );
                  });

                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {}
                      return true;
                    },
                    child: ListView.separated(
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Text(list[index].message);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 4,
                        );
                      },
                      itemCount: list.length,
                    ),
                  );
                },
              ),
            ),
            _inputLayout(),
          ],
        ),
      ),
    );
  }

  Widget _inputLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () async {
              //TODO image
            },
            child: Icon(
              Icons.photo,
              color: chatProvider.input.text.isEmpty ? Colors.blue : Colors.blue.shade100,
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2.0,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: TextField(
                controller: chatProvider.input,
                onChanged: (String text) {
                  setState(() {});
                },
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '輸入訊息',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
              8.0,
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: chatProvider.input.text.isEmpty
                  ? null
                  : () {
                      chatProvider.sendMessage(context, MessageType.text);
                    },
              child: Icon(
                Icons.send,
                color: chatProvider.input.text.isEmpty ? Colors.blue.shade100 : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
