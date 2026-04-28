import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/auth/sign_in_with_google.dart';
import '../providers/dependency_injection.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(_loginLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // TODO: navigate to AboutScreen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 32),
            const Text(
              'Bienvenido a Adopti',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Encuentra y reporta mascotas perdidas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => _signInWithGoogle(ref, context),
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: Text(
                isLoading ? 'Iniciando sesión...' : 'Iniciar sesión con Google',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(WidgetRef ref, BuildContext context) async {
    ref.read(_loginLoadingProvider.notifier).state = true;
    try {
      final signIn = SignInWithGoogle(ref.read(authRepositoryProvider));
      await signIn();
      if (context.mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      ref.read(_loginLoadingProvider.notifier).state = false;
    }
  }
}

final _loginLoadingProvider = StateProvider<bool>((ref) => false);
