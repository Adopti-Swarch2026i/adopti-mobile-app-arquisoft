import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/conversation.dart';
import '../../../core/theme/app_colors.dart';

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
    final unreadCount = conversation.unreadCount ?? 0;
    final hasUnread = unreadCount > 0;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: hasUnread ? colorScheme.primary.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                child: Text(
                  _otherUserName.isNotEmpty ? _otherUserName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _otherUserName,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                              color: colorScheme.onBackground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.lastMessage != null)
                          Text(
                            _formatDate(conversation.lastMessage!.timestamp),
                            style: textTheme.bodySmall?.copyWith(
                              color: hasUnread ? colorScheme.primary : colorScheme.onBackground.withOpacity(0.5),
                              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _lastMessageText ?? 'Sin mensajes',
                            style: textTheme.bodyMedium?.copyWith(
                              color: hasUnread ? colorScheme.onBackground : colorScheme.onBackground.withOpacity(0.6),
                              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0 && now.day == date.day) {
      return DateFormat.Hm().format(date);
    } else if (diff.inDays < 7) {
      switch (date.weekday) {
        case 1: return 'Lun';
        case 2: return 'Mar';
        case 3: return 'Mié';
        case 4: return 'Jue';
        case 5: return 'Vie';
        case 6: return 'Sáb';
        case 7: return 'Dom';
      }
    }
    return '${date.day}/${date.month}';
  }
}
