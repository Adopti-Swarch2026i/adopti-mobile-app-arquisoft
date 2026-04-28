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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.pets,
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Bienvenido a Adopti',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión para reportar y buscar mascotas',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 48),
              OutlinedButton.icon(
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
                  isLoading ? 'Iniciando sesión...' : 'Continuar con Google',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: colorScheme.outline, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // rounded.md
                  ),
                  foregroundColor: colorScheme.onBackground,
                ),
              ),
            ],
          ),
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
