import '../../entities/pet.dart';
import '../../repositories/pet_repository.dart';

class ListPets {
  final PetRepository _repository;

  const ListPets(this._repository);

  Future<PaginatedPets> call({
    PetStatus? status,
    PetSpecies? type,
    String? city,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) =>
      _repository.listPets(
        status: status,
        type: type,
        city: city,
        search: search,
        page: page,
        pageSize: pageSize,
      );
}
