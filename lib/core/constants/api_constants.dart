import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constantes de API endurecidas para el patrón Secure Channel Pattern.
///
/// Requisitos de seguridad (Laboratorio 5 — SwArch_2026i):
/// - Ninguna URL puede usar esquemas inseguros (http://, ws://) en release.
/// - Si falta una variable obligatoria, la app lanza [StateError].
class ApiConstants {
  static String _required(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key');
    }
    if (kReleaseMode &&
        !(value.startsWith('https://') || value.startsWith('wss://'))) {
      throw StateError('Insecure scheme for $key in release build: $value');
    }
    return value;
  }

  static String get petsBaseUrl => _required('PETS_API_URL');
  static String get chatGraphqlUrl => _required('CHAT_GRAPHQL_URL');
  static String get chatWsUrl => _required('CHAT_WS_URL');
  static String get matchingBaseUrl => _required('MATCHING_API_URL');
  static String get mediaBaseUrl => _required('MEDIA_API_URL');
  static String get notificationsBaseUrl => _required('NOTIFICATIONS_API_URL');

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
