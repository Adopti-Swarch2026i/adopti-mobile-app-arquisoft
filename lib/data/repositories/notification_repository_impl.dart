import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/notifications_api_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsApiDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<void> registerDeviceToken(String fcmToken, String platform) async {
    try {
      await _dataSource.registerDeviceToken(fcmToken, platform);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<PaginatedNotifications> getNotifications({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    // TODO: implement when endpoint is ready
    throw UnimplementedError();
  }
}
