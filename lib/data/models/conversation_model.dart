import '../../domain/entities/conversation.dart';

class ConversationModel {
  final String id;
  final List<String> participantIds;
  final List<String>? participantNames;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationModel({
    required this.id,
    required this.participantIds,
    this.participantNames,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final rawCreated = json['createdAt'];
    final rawUpdated = json['updatedAt'];

    DateTime parseTimestamp(dynamic value) {
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is double) {
        return DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());
      } else if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return ConversationModel(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantNames: (json['participantNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: parseTimestamp(rawCreated),
      updatedAt: parseTimestamp(rawUpdated),
    );
  }

  Conversation toEntity() => Conversation(
        id: id,
        participantIds: participantIds,
        participantNames: participantNames,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
