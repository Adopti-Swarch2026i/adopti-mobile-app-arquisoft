import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isMe;
  final DateTime timestamp;
  final String? senderName;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isMe,
    required this.timestamp,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? colorScheme.primary.withOpacity(0.9) : colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(6),
                  bottomRight: isMe ? const Radius.circular(6) : const Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMe && senderName != null && senderName!.isNotEmpty) ...[
                    Text(
                      senderName!,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondary.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    content,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isMe ? colorScheme.onPrimary : colorScheme.onSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat.Hm().format(timestamp),
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        color: isMe
                            ? colorScheme.onPrimary.withOpacity(0.7)
                            : colorScheme.onSecondary.withOpacity(0.6),
                      ),
                    ),
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
