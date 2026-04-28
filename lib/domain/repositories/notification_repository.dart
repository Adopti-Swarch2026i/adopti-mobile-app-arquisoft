class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.read,
  });
}

class PaginatedNotifications {
  final int total;
  final int page;
  final int pageSize;
  final List<NotificationItem> results;

  const PaginatedNotifications({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.results,
  });
}

abstract class NotificationRepository {
  Future<void> registerDeviceToken(String fcmToken, String platform);

  Future<PaginatedNotifications> getNotifications({
    required String userId,
    int page = 1,
    int pageSize = 20,
  });
}
