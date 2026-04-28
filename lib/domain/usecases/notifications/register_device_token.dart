import '../../repositories/notification_repository.dart';

class RegisterDeviceToken {
  final NotificationRepository _repository;

  const RegisterDeviceToken(this._repository);

  Future<void> call(String fcmToken, String platform) =>
      _repository.registerDeviceToken(fcmToken, platform);
}
