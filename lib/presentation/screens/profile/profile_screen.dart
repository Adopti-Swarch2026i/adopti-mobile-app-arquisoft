import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/usecases/auth/sign_out.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dependency_injection.dart';
import '../../providers/pets_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/shimmer_loading.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(petStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No has iniciado sesión'));
          }
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                      child: user.photoURL == null
                          ? Text(
                              user.displayName.isNotEmpty
                                  ? user.displayName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(fontSize: 32),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    if (user.phone != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.phone!,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(),
              statsAsync.when(
                data: (stats) => _StatsSection(stats: stats),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: ShimmerLoading(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatShimmer(),
                        _StatShimmer(),
                        _StatShimmer(),
                      ],
                    ),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notificaciones'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notificaciones próximamente')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Acerca de'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/about'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar sesión',
                    style: TextStyle(color: Colors.red)),
                onTap: () => _signOut(ref, context),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(currentUserProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
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

class _StatsSection extends StatelessWidget {
  final Map<String, int> stats;

  const _StatsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            label: 'Perdidos',
            value: stats['lost'] ?? 0,
            color: Colors.red,
          ),
          _StatItem(
            label: 'Encontrados',
            value: stats['found'] ?? 0,
            color: Colors.green,
          ),
          _StatItem(
            label: 'Reunidos',
            value: stats['reunited'] ?? 0,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _StatShimmer extends StatelessWidget {
  const _StatShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
