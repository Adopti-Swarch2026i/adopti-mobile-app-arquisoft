import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/pet.dart';
import '../../providers/pets_provider.dart';
import '../../widgets/pets/pet_card.dart';
import '../../widgets/pets/status_badge.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(activeFiltersProvider);
    final petsAsync = ref.watch(petListProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => context.push('/pets/filter'),
          ),
        ],
      ),
      body: petsAsync.when(
        data: (paginated) {
          if (paginated.results.isEmpty) {
            return const Center(child: Text('No hay mascotas reportadas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: paginated.results.length,
            itemBuilder: (context, index) {
              final pet = paginated.results[index];
              return PetCard(
                pet: pet,
                trailing: StatusBadge(status: pet.status),
                onTap: () => context.push('/pets/${pet.id}'),
              );
            },
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(petListProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pets/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
