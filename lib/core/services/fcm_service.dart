import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../data/datasources/remote/notifications_api_datasource.dart';

/// Handler top-level requerido por Firebase para mensajes en background.
/// No puede ser un método de instancia.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // En background/terminated no inicializamos todo el app state.
  // El SO muestra la notificación nativa automáticamente si el payload
  // contiene notification.title/body.
}

class FcmService {
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final NotificationsApiDataSource _notificationsApi;
  final GlobalKey<NavigatorState>? _navigatorKey;

  FcmService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
    required NotificationsApiDataSource notificationsApi,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications = localNotifications ?? FlutterLocalNotificationsPlugin(),
        _notificationsApi = notificationsApi,
        _navigatorKey = navigatorKey;

  Future<void> initialize() async {
    // 1. Solicitar permisos (iOS + Android 13+)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // 2. Configurar canal de notificación local (Android)
    const androidChannel = AndroidNotificationChannel(
      'adopti_default_channel',
      'Adopti Notificaciones',
      description: 'Canal principal para notificaciones push de Adopti',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // 3. Configurar handler de foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 4. Configurar handler de background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 5. Manejar notificación que abrió la app (terminated)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleDeepLink(initialMessage.data);
    }

    // 6. Obtener y registrar token FCM
    await _registerToken();

    // 7. Escuchar cambios de token
    _messaging.onTokenRefresh.listen(_onTokenRefresh);
  }

  Future<void> _registerToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        await _notificationsApi.registerDeviceToken(token, 'android');
      }
    } catch (e) {
      debugPrint('FCM token registration failed: $e');
    }
  }

  /// Fuerza el re-registro del token FCM (útil al cambiar de usuario)
  Future<void> forceRegisterToken() async {
    await _registerToken();
  }

  Future<void> _onTokenRefresh(String token) async {
    try {
      await _notificationsApi.registerDeviceToken(token, 'android');
    } catch (e) {
      debugPrint('FCM token refresh registration failed: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      message.hashCode,
      notification.title ?? 'Adopti',
      notification.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adopti_default_channel',
          'Adopti Notificaciones',
          channelDescription: 'Canal principal para notificaciones push de Adopti',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _handleDeepLink(data);
    } catch (_) {
      // Payload inválido, ignorar
    }
  }

  void _handleDeepLink(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    if (type == null) return;

    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    switch (type) {
      case 'chat.message.sent':
        final conversationId = data['conversationId'] as String?;
        if (conversationId != null) {
          context.push('/chat/$conversationId');
        }
        break;
      case 'match.found':
        final lostPetId = data['lostPetId'] as String?;
        if (lostPetId != null) {
          context.push('/pets/$lostPetId');
        }
        break;
      case 'pet.report.reunited':
        final petId = data['petId'] as String?;
        if (petId != null) {
          context.push('/pets/$petId');
        }
        break;
    }
  }
}
