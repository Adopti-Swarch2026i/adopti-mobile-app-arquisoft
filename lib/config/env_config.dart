import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get petsApiUrl =>
      dotenv.env['PETS_API_URL'] ?? 'http://10.0.2.2/api/pets';

  static String get chatGraphqlUrl =>
      dotenv.env['CHAT_GRAPHQL_URL'] ?? 'http://10.0.2.2/api/chat/graphql';

  static String get chatWsUrl =>
      dotenv.env['CHAT_WS_URL'] ?? 'ws://10.0.2.2/api/chat/ws';

  static String get matchingApiUrl =>
      dotenv.env['MATCHING_API_URL'] ?? 'http://10.0.2.2/api';

  static String get mediaApiUrl =>
      dotenv.env['MEDIA_API_URL'] ?? 'http://10.0.2.2/api/media';

  static String get notificationsApiUrl =>
      dotenv.env['NOTIFICATIONS_API_URL'] ?? 'http://10.0.2.2/api/notifications';
}
