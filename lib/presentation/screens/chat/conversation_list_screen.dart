import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat/conversation_tile.dart';
import '../../widgets/common/app_empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/shimmer_loading.dart';

class ConversationListScreen extends ConsumerWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Conversaciones')),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const AppEmptyState(
              icon: Icons.chat_bubble_outline,
              title: 'Inicia sesión',
              subtitle: 'Conecta con personas que han reportado mascotas o encontrado la tuya.',
            );
          }
          return _ConversationList(userId: user.id);
        },
        loading: () => const ConversationListShimmer(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(currentUserProvider),
        ),
      ),
    );
  }
}

class _ConversationList extends ConsumerWidget {
  final String userId;

  const _ConversationList({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider(userId));

    return conversationsAsync.when(
      data: (conversations) {
        if (conversations.isEmpty) {
          return const AppEmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'Aún no tienes conversaciones',
            subtitle: 'Cuando contactes a alguien sobre una mascota, aparecerá aquí.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(conversationsProvider(userId)),
          child: ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationTile(
                conversation: conversation,
                currentUserId: userId,
                onTap: () => context.push('/chat/${conversation.id}'),
              );
            },
          ),
        );
      },
      loading: () => const ConversationListShimmer(),
      error: (error, stack) => AppErrorWidget(
        message: error.toString(),
        onRetry: () => ref.invalidate(conversationsProvider(userId)),
      ),
    );
  }
}
