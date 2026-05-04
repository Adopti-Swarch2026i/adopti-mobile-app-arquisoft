import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/auth_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/shimmer_loading.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const AppEmptyState(
              icon: Icons.notifications_none,
              title: 'Inicia sesion',
              subtitle: 'Recibe alertas cuando alguien contacte sobre tu mascota.',
            );
          }
          return _NotificationList(userId: user.id);
        },
        loading: () => const _NotificationListShimmer(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
      ),
    );
  }
}

class _NotificationList extends ConsumerWidget {
  final String userId;

  const _NotificationList({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider(userId));
    final colorScheme = Theme.of(context).colorScheme;

    return notificationsAsync.when(
      data: (paginated) {
        final notifications = paginated.results;
        if (notifications.isEmpty) {
          return const AppEmptyState(
            icon: Icons.notifications_none,
            title: 'No tienes notificaciones',
            subtitle: 'Te avisaremos cuando haya novedades sobre tus reportes.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(notificationsProvider(userId)),
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: n.read
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(
                    n.read ? Icons.notifications_none : Icons.notifications,
                    color: n.read
                        ? colorScheme.onSurface.withValues(alpha: 0.4)
                        : colorScheme.primary,
                  ),
                ),
                title: Text(
                  n.title,
                  style: TextStyle(
                    fontWeight: n.read ? FontWeight.normal : FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.body,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(n.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
                onTap: () {
                  _handleNotificationTap(context, n.title, n.body);
                },
              );
            },
          ),
        );
      },
      loading: () => const _NotificationListShimmer(),
      error: (error, stack) {
        final errorMessage = _friendlyErrorMessage(error.toString());
        return AppErrorWidget(
          message: errorMessage,
          onRetry: () => ref.invalidate(notificationsProvider(userId)),
        );
      },
    );
  }

  String _friendlyErrorMessage(String rawError) {
    final lower = rawError.toLowerCase();
    if (lower.contains('403') || lower.contains('forbidden')) {
      return 'No tienes permisos para ver notificaciones en este momento. Intenta cerrar sesion y volver a entrar.';
    }
    if (lower.contains('401') || lower.contains('unauthorized')) {
      return 'Tu sesion expiro. Por favor, inicia sesion de nuevo.';
    }
    if (lower.contains('timeout') || lower.contains('connection')) {
      return 'No se pudo conectar con el servidor. Verifica tu conexion a internet.';
    }
    if (lower.contains('404')) {
      return 'El servicio de notificaciones no esta disponible en este momento.';
    }
    return 'No se pudieron cargar las notificaciones. Intenta de nuevo mas tarde.';
  }

  void _handleNotificationTap(BuildContext context, String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title: $body')),
    );
  }
}

class _NotificationListShimmer extends StatelessWidget {
  const _NotificationListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return const ListTile(
          leading: ShimmerLoading(child: CircleAvatar(radius: 20)),
          title: ShimmerLoading(
            child: SizedBox(height: 16, width: double.infinity),
          ),
          subtitle: ShimmerLoading(
            child: SizedBox(height: 14, width: double.infinity),
          ),
        );
      },
    );
  }
}
