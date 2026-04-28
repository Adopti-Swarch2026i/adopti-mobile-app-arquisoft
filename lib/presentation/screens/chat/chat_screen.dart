import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/message.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/dependency_injection.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    _messageCtrl.clear();

    try {
      final repo = ref.read(chatRepositoryProvider);
      await repo.sendMessage(widget.conversationId, text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error enviando mensaje: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.conversationId));
    final streamAsync = ref.watch(messageStreamProvider(widget.conversationId));
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (historicalMessages) {
                return streamAsync.when(
                  data: (liveMessage) {
                    // Combine historical + live messages
                    final allMessages = [...historicalMessages];
                    if (!allMessages.any((m) => m.id == liveMessage.id)) {
                      allMessages.add(liveMessage);
                    }
                    allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                    return _MessageList(
                      messages: allMessages,
                      scrollCtrl: _scrollCtrl,
                      currentUserId: currentUserAsync.valueOrNull?.id,
                    );
                  },
                  loading: () => _MessageList(
                    messages: historicalMessages,
                    scrollCtrl: _scrollCtrl,
                    currentUserId: currentUserAsync.valueOrNull?.id,
                  ),
                  error: (_, __) => _MessageList(
                    messages: historicalMessages,
                    scrollCtrl: _scrollCtrl,
                    currentUserId: currentUserAsync.valueOrNull?.id,
                  ),
                );
              },
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, stack) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(messagesProvider(widget.conversationId)),
              ),
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !_isSending,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _isSending ? null : _sendMessage,
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollCtrl;
  final String? currentUserId;

  const _MessageList({
    required this.messages,
    required this.scrollCtrl,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('No hay mensajes aún'),
      );
    }
    return ListView.builder(
      controller: scrollCtrl,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(
          content: message.content,
          isMe: message.senderId == currentUserId,
          timestamp: message.timestamp,
        );
      },
    );
  }
}
