import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;
  final Widget? trailing;

  const PetCard({super.key, required this.pet, this.onTap, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: pet.imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: pet.imageUrls.first,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                        errorWidget: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.breed} • ${pet.city}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet.status.name.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor(pet.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Icons.pets, color: Colors.grey),
    );
  }

  Color _statusColor(PetStatus status) {
    return switch (status) {
      PetStatus.lost => Colors.red,
      PetStatus.found => Colors.green,
      PetStatus.reunited => Colors.orange,
    };
  }
}
