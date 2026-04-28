import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/pet.dart';
import 'status_badge.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({super.key, required this.pet, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String speciesLabel = pet.species == 'dog'
        ? 'Perro'
        : pet.species == 'cat'
            ? 'Gato'
            : pet.species == 'bird'
                ? 'Ave'
                : 'Otro';
    String subtitle =
        pet.breed.isNotEmpty ? '$speciesLabel • ${pet.breed}' : speciesLabel;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Gradient and Badge
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: pet.imageUrls.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: pet.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _placeholder(context),
                          errorWidget: (_, __, ___) => _placeholder(context),
                        )
                      : _placeholder(context),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Status Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: StatusBadge(status: pet.status),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pet.city,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(pet.createdAt),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(Icons.pets, color: Colors.grey, size: 48),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays}d';
    return '${date.day}/${date.month}/${date.year}';
  }
}
