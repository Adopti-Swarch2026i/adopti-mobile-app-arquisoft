import 'dart:convert';

import '../../domain/repositories/notification_repository.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final eventType = json['EventType'] as String? ?? json['eventType'] as String? ?? 'unknown';
    final payload = json['Payload'] as String? ?? json['payload'] as String? ?? '{}';
    final status = json['Status'] as String? ?? json['status'] as String? ?? '';
    final createdAt = json['CreatedAt'] as String? ?? json['createdAt'] as String?;

    return NotificationModel(
      id: (json['ID'] ?? json['id']).toString(),
      title: _eventTypeToTitle(eventType),
      body: _extractBody(eventType, payload),
      timestamp: createdAt != null ? DateTime.parse(createdAt) : DateTime.now(),
      read: status == 'sent' || status == 'skipped_no_token' || status == 'skipped_no_recipient',
    );
  }

  NotificationItem toEntity() => NotificationItem(
        id: id,
        title: title,
        body: body,
        timestamp: timestamp,
        read: read,
      );

  static String _eventTypeToTitle(String eventType) {
    return switch (eventType) {
      'chat.message.sent' => 'Nuevo mensaje',
      'pet.report.reunited' => 'Mascota reunida',
      'match.found' => 'Posible coincidencia',
      'pet.report.created' => 'Nuevo reporte',
      'pet.image.uploaded' => 'Imagen subida',
      _ => 'Notificación',
    };
  }

  static String _extractBody(String eventType, String payload) {
    try {
      final map = jsonDecode(payload) as Map<String, dynamic>;
      return switch (eventType) {
        'chat.message.sent' => map['contentPreview'] as String? ?? map['content'] as String? ?? 'Tienes un nuevo mensaje',
        'pet.report.reunited' => 'Tu mascota fue reunida con su familia.',
        'match.found' => 'Se encontró una posible coincidencia para tu reporte.',
        'pet.report.created' => map['description'] as String? ?? 'Se creó un nuevo reporte de mascota.',
        'pet.image.uploaded' => 'Tu imagen se subió correctamente.',
        _ => payload,
      };
    } catch (_) {
      return payload;
    }
  }
}
