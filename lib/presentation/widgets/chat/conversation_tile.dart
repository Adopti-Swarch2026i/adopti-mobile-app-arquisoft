import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/conversation.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final VoidCallback? onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    this.onTap,
  });

  String get _otherUserName {
    final index = conversation.participantIds.indexOf(currentUserId);
    if (index != -1 && conversation.participantNames != null) {
      final otherIndex = index == 0 ? 1 : 0;
      if (otherIndex < conversation.participantNames!.length) {
        return conversation.participantNames![otherIndex];
      }
    }
    return 'Usuario';
  }

  String? get _lastMessageText {
    return conversation.lastMessage?.content;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          _otherUserName.isNotEmpty ? _otherUserName[0].toUpperCase() : '?',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
      title: Text(_otherUserName),
      subtitle: _lastMessageText != null
          ? Text(
              _lastMessageText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.lastMessage != null)
            Text(
              DateFormat.Hm().format(conversation.lastMessage!.timestamp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          if ((conversation.unreadCount ?? 0) > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
