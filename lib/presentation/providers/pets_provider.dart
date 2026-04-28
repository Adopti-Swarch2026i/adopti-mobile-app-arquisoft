import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/pet.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/pet_repository.dart';
import 'dependency_injection.dart';

class PetListState {
  final List<Pet> pets;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const PetListState({
    this.pets = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  PetListState copyWith({
    List<Pet>? pets,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PetListState(
      pets: pets ?? this.pets,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PetListParams {
  final PetStatus? status;
  final PetSpecies? type;
  final String? city;
  final String? search;
  final int page;
  final int pageSize;

  const PetListParams({
    this.status,
    this.type,
    this.city,
    this.search,
    this.page = 1,
    this.pageSize = 20,
  });

  PetListParams copyWith({
    PetStatus? status,
    PetSpecies? type,
    String? city,
    String? search,
    int? page,
    int? pageSize,
  }) {
    return PetListParams(
      status: status ?? this.status,
      type: type ?? this.type,
      city: city ?? this.city,
      search: search ?? this.search,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class SearchPetsParams {
  final String? query;
  final String? breed;
  final String? city;
  final PetSpecies? type;
  final PetStatus? status;
  final int page;
  final int pageSize;

  const SearchPetsParams({
    this.query,
    this.breed,
    this.city,
    this.type,
    this.status,
    this.page = 1,
    this.pageSize = 20,
  });
}

final activeFiltersProvider = StateProvider<PetListParams>((ref) {
  return const PetListParams();
});

// Legacy provider for simple list usage (kept for compatibility)
final petListProvider = FutureProvider.family<PaginatedPets, PetListParams>(
  (ref, params) async {
    final repo = ref.watch(petRepositoryProvider);
    return repo.listPets(
      status: params.status,
      type: params.type,
      city: params.city,
      search: params.search,
      page: params.page,
      pageSize: params.pageSize,
    );
  },
);

// Notifier for infinite pagination + pull-to-refresh
class PetListNotifier extends AsyncNotifier<PetListState> {
  static const _pageSize = 20;

  @override
  Future<PetListState> build() async {
    final filters = ref.watch(activeFiltersProvider);
    final repo = ref.watch(petRepositoryProvider);
    final result = await repo.listPets(
      status: filters.status,
      type: filters.type,
      city: filters.city,
      search: filters.search,
      page: 1,
      pageSize: _pageSize,
    );
    return PetListState(
      pets: result.results,
      page: 1,
      hasMore: result.results.length == _pageSize,
      isLoadingMore: false,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    final filters = ref.read(activeFiltersProvider);
    final repo = ref.read(petRepositoryProvider);

    try {
      final nextPage = current.page + 1;
      final result = await repo.listPets(
        status: filters.status,
        type: filters.type,
        city: filters.city,
        search: filters.search,
        page: nextPage,
        pageSize: _pageSize,
      );

      final newPets = [...current.pets, ...result.results];
      state = AsyncValue.data(PetListState(
        pets: newPets,
        page: nextPage,
        hasMore: result.results.length == _pageSize,
        isLoadingMore: false,
      ));
    } catch (err, stack) {
      state = AsyncValue<PetListState>.error(err, stack).copyWithPrevious(
        AsyncValue.data(current.copyWith(isLoadingMore: false)),
      );
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

final petListNotifierProvider =
    AsyncNotifierProvider<PetListNotifier, PetListState>(
  PetListNotifier.new,
);

final searchPetsProvider =
    FutureProvider.family<PaginatedPets, SearchPetsParams>(
  (ref, params) async {
    final repo = ref.watch(petRepositoryProvider);
    return repo.searchPets(
      query: params.query,
      breed: params.breed,
      city: params.city,
      type: params.type,
      status: params.status,
      page: params.page,
      pageSize: params.pageSize,
    );
  },
);

final petDetailProvider = FutureProvider.family<Pet, String>(
  (ref, id) async {
    final repo = ref.watch(petRepositoryProvider);
    return repo.getPetDetail(id);
  },
);

final petStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final repo = ref.watch(petRepositoryProvider);
  return repo.getStats();
});

final createReportProvider = FutureProvider.family<Pet, ReportInput>(
  (ref, input) async {
    final repo = ref.watch(petRepositoryProvider);
    return repo.createReport(input);
  },
);
