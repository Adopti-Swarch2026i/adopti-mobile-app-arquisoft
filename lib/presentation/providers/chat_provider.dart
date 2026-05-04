import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import 'dependency_injection.dart';

final conversationsProvider = FutureProvider.family<List<Conversation>, String>(
  (ref, userId) async {
    final repo = ref.watch(chatRepositoryProvider);
    return repo.getConversations(userId);
  },
);

final messagesProvider =
    FutureProvider.family<List<Message>, String>(
  (ref, conversationId) async {
    final repo = ref.watch(chatRepositoryProvider);
    return repo.getMessages(conversationId);
  },
);

final messageStreamProvider = StreamProvider.autoDispose.family<List<Message>, String>(
  (ref, conversationId) async* {
    final repo = ref.watch(chatRepositoryProvider);
    await repo.connectWebSocket();
    ref.onDispose(() => repo.disconnectWebSocket());

    final liveMessages = <Message>[];
    await for (final message in repo.subscribeToMessages(conversationId)) {
      if (!liveMessages.any((m) => m.id == message.id)) {
        liveMessages.add(message);
      }
      liveMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      yield [...liveMessages];
    }
  },
);
