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
    return PaginatedNotificationsModel(
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      results: (json['results'] as List<dynamic>)
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
