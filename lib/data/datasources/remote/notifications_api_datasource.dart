import 'package:dio/dio.dart';

import '../../../core/errors/exceptions.dart';

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
}
