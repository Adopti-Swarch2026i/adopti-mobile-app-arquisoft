import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/pet.dart';

class StatusBadge extends StatelessWidget {
  final PetStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      PetStatus.lost => ('Perdido', AppColors.lost),
      PetStatus.found => ('Encontrado', AppColors.found),
      PetStatus.reunited => ('Reunido', AppColors.reunited),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
