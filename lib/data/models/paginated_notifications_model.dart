import '../../domain/repositories/notification_repository.dart';
import 'notification_model.dart';

class PaginatedNotificationsModel {
  final int total;
  final int page;
  final int pageSize;
  final List<NotificationModel> results;

  const PaginatedNotificationsModel({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.results,
  });

  factory PaginatedNotificationsModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as List<dynamic>? ?? []);
    final limit = json['limit'] as int? ?? 20;
    final offset = json['offset'] as int? ?? 0;

    return PaginatedNotificationsModel(
      total: offset + data.length,
      page: limit > 0 ? (offset ~/ limit) + 1 : 1,
      pageSize: limit,
      results: data
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  PaginatedNotifications toEntity() => PaginatedNotifications(
        total: total,
        page: page,
        pageSize: pageSize,
        results: results.map((r) => r.toEntity()).toList(),
      );
}
