import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/usecases/auth/sign_out.dart';
import '../../providers/dependency_injection.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Usuario'),
            subtitle: Text('usuario@email.com'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificaciones'),
            onTap: () {
              // TODO: navigate to notifications
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            onTap: () {
              // TODO: navigate to AboutScreen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
            onTap: () => _signOut(ref, context),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(WidgetRef ref, BuildContext context) async {
    final signOut = SignOut(ref.read(authRepositoryProvider));
    await signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }
}
