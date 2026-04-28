import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const ConversationTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
    );
  }
}
