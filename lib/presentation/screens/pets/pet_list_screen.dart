import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/pets_provider.dart';
import '../../widgets/pets/pet_card.dart';
import '../../widgets/pets/status_badge.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/shimmer_loading.dart';

class PetListScreen extends ConsumerStatefulWidget {
  const PetListScreen({super.key});

  @override
  ConsumerState<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends ConsumerState<PetListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(petListNotifierProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(petListNotifierProvider);

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
        data: (state) => RefreshIndicator(
          onRefresh: () => ref.read(petListNotifierProvider.notifier).refresh(),
          child: state.pets.isEmpty
              ? const Center(child: Text('No hay mascotas reportadas'))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: state.pets.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.pets.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final pet = state.pets[index];
                    return PetCard(
                      pet: pet,
                      trailing: StatusBadge(status: pet.status),
                      onTap: () => context.push('/pets/${pet.id}'),
                    );
                  },
                ),
        ),
        loading: () => const PetListShimmer(),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(petListNotifierProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/pets/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
