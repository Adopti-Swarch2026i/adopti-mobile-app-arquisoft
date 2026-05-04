import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/firebase_auth_datasource.dart';
import '../../core/services/fcm_service.dart';
import 'dependency_injection.dart';

/// Widget que inicializa Firebase Cloud Messaging cuando el usuario
/// está autenticado. Se coloca como ancestro de MaterialApp.router.
/// Re-registra el token FCM cuando cambia el usuario.
class FcmInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const FcmInitializer({super.key, required this.child});

  @override
  ConsumerState<FcmInitializer> createState() => _FcmInitializerState();
}

class _FcmInitializerState extends ConsumerState<FcmInitializer> {
  String? _lastUserId;

  @override
  void initState() {
    super.initState();
    _listenAuthChanges();
  }

  bool _initialized = false;

  void _listenAuthChanges() {
    final authState = ref.read(firebaseAuthDataSourceProvider).authStateChanges;
    authState.listen((user) async {
      if (user != null && user.id != _lastUserId) {
        _lastUserId = user.id;
        final fcmService = ref.read(fcmServiceProvider);
        if (!_initialized) {
          _initialized = true;
          await fcmService.initialize();
        } else {
          // Solo re-registrar el token para el nuevo usuario
          await fcmService.forceRegisterToken();
        }
      } else if (user == null) {
        _lastUserId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
