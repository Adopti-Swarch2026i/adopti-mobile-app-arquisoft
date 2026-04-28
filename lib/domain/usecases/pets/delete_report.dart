import '../../repositories/pet_repository.dart';

class DeleteReport {
  final PetRepository _repository;

  const DeleteReport(this._repository);

  Future<void> call(String id) => _repository.deleteReport(id);
}
