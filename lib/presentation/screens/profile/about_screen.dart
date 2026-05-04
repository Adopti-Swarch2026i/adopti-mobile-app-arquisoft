import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/animations/app_animations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const List<_TeamMember> _team = [
    _TeamMember(name: 'Juan Carlos Andrade Unigarro', role: 'Mobile Flutter'),
    _TeamMember(name: 'Julian David Osorio Amaya', role: 'Backend / Notificaciones'),
    _TeamMember(name: 'Juan David Rodríguez Gómez', role: 'Backend / Matching'),
    _TeamMember(name: 'Cristian Daniel Montañez Pineda', role: 'Frontend Web SSR'),
    _TeamMember(name: 'Justin Rodriguez Sanchez', role: 'Backend / Media Service'),
    _TeamMember(name: 'Eduard Harvey Patiño Balaguera', role: 'Infraestructura / DevOps'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // App branding
            FadeScaleEntrance(
              duration: AppDurations.entrance,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF2D8B63)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.pets,
                  size: 56,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeScaleEntrance(
              delay: const Duration(milliseconds: 80),
              duration: AppDurations.entrance,
              child: Text(
                'Adopti',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 4),
            FadeScaleEntrance(
              delay: const Duration(milliseconds: 120),
              duration: AppDurations.entrance,
              child: Text(
                'Arquitectura de Software 2026-I',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            FadeScaleEntrance(
              delay: const Duration(milliseconds: 160),
              duration: AppDurations.entrance,
              child: Text(
                'Versión 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Team section
            FadeScaleEntrance(
              delay: const Duration(milliseconds: 200),
              duration: AppDurations.entrance,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Equipo de desarrollo',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ..._team.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              return FadeScaleEntrance(
                delay: Duration(milliseconds: 240 + (index * 40)),
                duration: AppDurations.entrance,
                child: _MemberTile(
                  name: member.name,
                  role: member.role,
                ),
              );
            }),
            const SizedBox(height: 32),
            FadeScaleEntrance(
              delay: const Duration(milliseconds: 500),
              duration: AppDurations.entrance,
              child: Text(
                '© 2026 Adopti. Todos los derechos reservados.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
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
