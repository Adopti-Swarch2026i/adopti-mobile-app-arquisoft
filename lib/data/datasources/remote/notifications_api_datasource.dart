import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';
import '../../models/paginated_notifications_model.dart';

class NotificationsApiDataSource {
  final Dio _dio;

  NotificationsApiDataSource(this._dio);

  Future<void> registerDeviceToken(String fcmToken, String platform) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/notifications/device-token',
        data: {
          'token': fcmToken,
          'platform': platform,
        },
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to register device token');
    }
  }

  Future<PaginatedNotificationsModel> getNotifications({
    required String userId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/notifications',
        queryParameters: {
          'userId': userId,
          'page': page,
          'page_size': pageSize,
        },
      );
      return PaginatedNotificationsModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch notifications');
    }
  }
}
