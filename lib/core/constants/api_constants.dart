import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get petsBaseUrl =>
      dotenv.env['PETS_API_URL'] ?? 'http://10.0.2.2/api/pets';

  static String get chatGraphqlUrl =>
      dotenv.env['CHAT_GRAPHQL_URL'] ?? 'http://10.0.2.2/api/chat/graphql';

  static String get chatWsUrl =>
      dotenv.env['CHAT_WS_URL'] ?? 'ws://10.0.2.2/api/chat/ws';

  static String get matchingBaseUrl =>
      dotenv.env['MATCHING_API_URL'] ?? 'http://10.0.2.2/api';

  static String get mediaBaseUrl =>
      dotenv.env['MEDIA_API_URL'] ?? 'http://10.0.2.2/api/media';

  static String get notificationsBaseUrl =>
      dotenv.env['NOTIFICATIONS_API_URL'] ?? 'http://10.0.2.2/api/notifications';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
