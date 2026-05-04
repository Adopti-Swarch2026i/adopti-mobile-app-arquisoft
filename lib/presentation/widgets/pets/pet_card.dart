import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/animations/app_animations.dart';
import '../../../domain/entities/pet.dart';
import 'status_badge.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;
  final int? index;

  const PetCard({super.key, required this.pet, this.onTap, this.index});

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

    Widget card = Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Gradient and Badge
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Hero(
                    tag: 'pet-image-${pet.id}',
                    child: pet.imageUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: pet.imageUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => _placeholder(context),
                            errorWidget: (_, __, ___) => _placeholder(context),
                          )
                        : _placeholder(context),
                  ),
                ),
                // Gradient overlay at bottom for text readability
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 1.0],
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
                // Name overlay at bottom of image
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                    subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
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
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          pet.city,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(pet.createdAt),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
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

    // Emil: Press feedback con scale 0.97
    card = PressableScale(
      onTap: onTap,
      child: card,
    );

    // Stagger animation si se proporciona index
    if (index != null) {
      card = FadeScaleEntrance(
        delay: AppDurations.staggerItem(index!),
        duration: AppDurations.entrance,
        child: card,
      );
    }

    return card;
  }

  Widget _placeholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF3A322C) : Colors.grey.shade200,
      child: Center(
        child: Icon(Icons.pets, color: isDark ? Colors.white38 : Colors.grey, size: 48),
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
