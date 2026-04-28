import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/pet.dart';
import '../../providers/pets_provider.dart';
import '../../widgets/pets/status_badge.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';

class PetDetailScreen extends ConsumerWidget {
  final String petId;

  const PetDetailScreen({super.key, required this.petId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petAsync = ref.watch(petDetailProvider(petId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white, shadows: [
          Shadow(
            color: Colors.black45,
            offset: Offset(0, 1),
            blurRadius: 4,
          ),
        ]),
      ),
      body: petAsync.when(
        data: (pet) => _PetDetailBody(pet: pet),
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(petDetailProvider(petId)),
        ),
      ),
    );
  }
}

class _PetDetailBody extends StatelessWidget {
  final Pet pet;

  const _PetDetailBody({required this.pet});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Gallery at Top
          SizedBox(
            height: size.height * 0.45,
            child: _ImageGallery(imageUrls: pet.imageUrls),
          ),
          
          // Overlapping content card
          Transform.translate(
            offset: const Offset(0, -32),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row: Title & Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.name,
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pet.breed.isNotEmpty
                                    ? '${_speciesLabel(pet.species)} • ${pet.breed}'
                                    : _speciesLabel(pet.species),
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(status: pet.status),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Detail Grid
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          if (pet.color.isNotEmpty || pet.age.isNotEmpty) ...[
                            Row(
                              children: [
                                if (pet.color.isNotEmpty)
                                  Expanded(child: _StatCard(label: 'Color', value: pet.color)),
                                if (pet.color.isNotEmpty && pet.age.isNotEmpty)
                                  const SizedBox(width: 16),
                                if (pet.age.isNotEmpty)
                                  Expanded(child: _StatCard(label: 'Edad', value: pet.age)),
                              ],
                            ),
                            const Divider(height: 32),
                          ],
                          _InfoRow(icon: Icons.location_on, value: '${pet.location}, ${pet.city}'),
                          const SizedBox(height: 12),
                          _InfoRow(icon: Icons.calendar_today, value: _formatDate(pet.date)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    if (pet.description.isNotEmpty) ...[
                      Text(
                        'Descripción',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pet.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Reporter Info
                    Text(
                      'Reportado por',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.person, value: pet.reporterName),
                    if (pet.contactPhone != null && pet.contactPhone!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _InfoRow(icon: Icons.phone, value: pet.contactPhone!),
                    ],
                    
                    const SizedBox(height: 32),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chat próximamente')),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: Text(
                          pet.status == PetStatus.lost
                              ? 'Contactar al dueño'
                              : 'Contactar al reportante',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _speciesLabel(PetSpecies species) {
    switch (species) {
      case PetSpecies.dog: return 'Perro';
      case PetSpecies.cat: return 'Gato';
      case PetSpecies.bird: return 'Ave';
      default: return 'Otro';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const _ImageGallery({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.pets, size: 80, color: Colors.grey)),
      );
    }
    return PageView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: imageUrls[index],
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (_, __, ___) => Container(
            color: Colors.grey.shade200,
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InfoRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurface.withOpacity(0.5)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
