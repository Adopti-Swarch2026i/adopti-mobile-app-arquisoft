import '../../entities/pet.dart';
import '../../entities/report.dart';
import '../../repositories/pet_repository.dart';

class UpdateReport {
  final PetRepository _repository;

  const UpdateReport(this._repository);

  Future<Pet> call(String id, ReportInput input) =>
      _repository.updateReport(id, input);
}
