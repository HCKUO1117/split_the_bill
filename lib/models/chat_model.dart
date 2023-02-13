enum MessageType { text, image }

extension MessageTypeEX on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
    }
  }
}

class ChatModel {
  String message;
  DateTime time;
  String senderId;
  MessageType type;
  bool cache;

  ChatModel({
    required this.message,
    required this.time,
    required this.senderId,
    required this.type,
    required this.cache,
  });
}
