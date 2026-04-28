import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(title: const Text('Detalle')),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageGallery(imageUrls: pet.imageUrls),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pet.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    StatusBadge(status: pet.status),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.pets, label: 'Raza', value: pet.breed),
                _InfoRow(icon: Icons.color_lens, label: 'Color', value: pet.color),
                _InfoRow(icon: Icons.cake, label: 'Edad', value: pet.age),
                _InfoRow(icon: Icons.location_on, label: 'Ubicación', value: '${pet.location}, ${pet.city}'),
                const Divider(height: 32),
                Text(
                  'Descripción',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(pet.description),
                const Divider(height: 32),
                Text(
                  'Reportado por',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(pet.reporterName),
                if (pet.contactPhone != null && pet.contactPhone!.isNotEmpty)
                  _InfoRow(icon: Icons.phone, label: 'Teléfono', value: pet.contactPhone!),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      // TODO: create conversation and navigate to chat
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat próximamente')),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Contactar'),
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

class _ImageGallery extends StatelessWidget {
  final List<String> imageUrls;

  const _ImageGallery({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.pets, size: 80, color: Colors.grey)),
      );
    }
    return SizedBox(
      height: 250,
      child: PageView.builder(
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
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
