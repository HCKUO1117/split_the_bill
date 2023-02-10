import 'package:flutter/material.dart';
import 'package:split_the_bill/models/user_model.dart';
import 'package:split_the_bill/providers/chat_provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel userModel;

  const ChatPage({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatProvider chatProvider;

  @override
  void initState() {
    chatProvider = ChatProvider(userModel: widget.userModel);
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
                      widget.userModel.name,
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
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo){
                      if(scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){

                      }
                      return true;
                    },
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return SizedBox();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 4,
                        );
                      },
                      itemCount: 0,
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
                onChanged: (String text) {},
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
                      //TODO send
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
