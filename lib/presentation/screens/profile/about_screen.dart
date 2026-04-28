import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<_TeamMember> _team = [
    _TeamMember(name: 'Eduard Andres Hurtado', role: 'Backend / DevOps'),
    _TeamMember(name: 'Julian Camilo Pinilla', role: 'Backend / Notificaciones'),
    _TeamMember(name: 'Justin Stiven Oriz Gallego', role: 'Backend / Media Service'),
    _TeamMember(name: 'Juan Carlos Andrade Unigarro', role: 'Mobile Flutter'),
    _TeamMember(name: 'Cristian Camilo Lopez', role: 'Frontend Web'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.pets,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Adopti',
              style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Arquitectura de Software 2026-I',
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Versión 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Equipo de desarrollo',
                style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            ..._team.map(
              (member) => _MemberTile(
                name: member.name,
                role: member.role,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '© 2026 Adopti. Todos los derechos reservados.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamMember {
  final String name;
  final String role;
  const _TeamMember({required this.name, required this.role});
}

class _MemberTile extends StatelessWidget {
  final String name;
  final String role;

  const _MemberTile({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withAlpha(30),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
