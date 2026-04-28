import '../../entities/pet.dart';
import '../../repositories/pet_repository.dart';

class SearchPets {
  final PetRepository _repository;

  const SearchPets(this._repository);

  Future<PaginatedPets> call({
    String? query,
    String? breed,
    String? city,
    PetSpecies? type,
    PetStatus? status,
    int page = 1,
    int pageSize = 20,
  }) =>
      _repository.searchPets(
        query: query,
        breed: breed,
        city: city,
        type: type,
        status: status,
        page: page,
        pageSize: pageSize,
      );
}
