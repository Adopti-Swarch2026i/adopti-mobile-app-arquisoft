import '../../entities/pet.dart';
import '../../repositories/pet_repository.dart';

class GetPetDetail {
  final PetRepository _repository;

  const GetPetDetail(this._repository);

  Future<Pet> call(String id) => _repository.getPetDetail(id);
}
