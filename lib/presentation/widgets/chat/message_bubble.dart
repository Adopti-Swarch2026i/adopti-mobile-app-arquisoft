import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isMe;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isMe ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
