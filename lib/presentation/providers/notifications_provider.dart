import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/notification_repository.dart';
import 'dependency_injection.dart';

final notificationsProvider = FutureProvider.family<PaginatedNotifications, String>(
  (ref, userId) async {
    final repo = ref.watch(notificationRepositoryProvider);
    return repo.getNotifications(userId: userId);
  },
);
