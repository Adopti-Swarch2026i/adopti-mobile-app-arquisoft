import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuración de variables de entorno endurecida para el patrón
/// Secure Channel Pattern (Laboratorio 5 — SwArch_2026i).
///
/// Requisitos de seguridad:
/// - Ninguna URL puede usar esquemas inseguros (http://, ws://) en release.
/// - Si falta una variable obligatoria, la app lanza [StateError] en tiempo
///   de ejecución en lugar de caer silenciosamente a un default inseguro.
class EnvConfig {
  static String _required(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key');
    }
    // Defensa en profundidad: bloquear HTTP/WS en producción.
    if (kReleaseMode &&
        !(value.startsWith('https://') || value.startsWith('wss://'))) {
      throw StateError(
          'Insecure scheme for $key in release build: $value');
    }
    return value;
  }

  static String get petsApiUrl => _required('PETS_API_URL');
  static String get chatGraphqlUrl => _required('CHAT_GRAPHQL_URL');
  static String get chatWsUrl => _required('CHAT_WS_URL');
  static String get matchingApiUrl => _required('MATCHING_API_URL');
  static String get mediaApiUrl => _required('MEDIA_API_URL');
  static String get notificationsApiUrl => _required('NOTIFICATIONS_API_URL');
}
