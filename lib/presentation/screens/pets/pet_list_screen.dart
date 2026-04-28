import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/pets_provider.dart';

class PetListScreen extends ConsumerWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(
      searchPetsProvider(const SearchPetsParams()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: navigate to PetFilterScreen
            },
          ),
        ],
      ),
      body: petsAsync.when(
        data: (paginated) {
          if (paginated.results.isEmpty) {
            return const Center(child: Text('No hay mascotas reportadas'));
          }
          return ListView.builder(
            itemCount: paginated.results.length,
            itemBuilder: (context, index) {
              final pet = paginated.results[index];
              return ListTile(
                leading: pet.imageUrls.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(pet.imageUrls.first),
                      )
                    : const CircleAvatar(child: Icon(Icons.pets)),
                title: Text(pet.name),
                subtitle: Text('${pet.status.name} - ${pet.city}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: navigate to PetDetailScreen
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navigate to PetCreateScreen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
