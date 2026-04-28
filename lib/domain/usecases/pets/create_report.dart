import '../../entities/pet.dart';
import '../../entities/report.dart';
import '../../repositories/pet_repository.dart';

class CreateReport {
  final PetRepository _repository;

  const CreateReport(this._repository);

  Future<Pet> call(ReportInput input) => _repository.createReport(input);
}
