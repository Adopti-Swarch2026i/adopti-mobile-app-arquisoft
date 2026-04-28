import 'message.dart';

class Conversation {
  final String id;
  final List<String> participantIds;
  final List<String>? participantNames;
  final Message? lastMessage;
  final int? unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.participantIds,
    this.participantNames,
    this.lastMessage,
    this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });
}
