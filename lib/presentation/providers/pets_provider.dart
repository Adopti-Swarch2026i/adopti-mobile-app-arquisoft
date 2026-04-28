import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/pet.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/pet_repository.dart';
import 'dependency_injection.dart';

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
