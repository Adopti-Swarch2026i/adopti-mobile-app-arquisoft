import '../../domain/entities/message.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final rawTimestamp = json['timestamp'];
    DateTime parsed;
    if (rawTimestamp is int) {
      parsed = DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    } else if (rawTimestamp is double) {
      parsed = DateTime.fromMillisecondsSinceEpoch((rawTimestamp * 1000).toInt());
    } else {
      parsed = DateTime.now();
    }

    return MessageModel(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: parsed,
    );
  }

  Message toEntity() => Message(
        id: id,
        conversationId: conversationId,
        senderId: senderId,
        content: content,
        timestamp: timestamp,
      );
}
