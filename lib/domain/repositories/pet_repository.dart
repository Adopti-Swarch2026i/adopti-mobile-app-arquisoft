import '../entities/pet.dart';
import '../entities/report.dart';

class PaginatedPets {
  final int total;
  final int page;
  final int pageSize;
  final List<Pet> results;

  const PaginatedPets({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.results,
  });
}

abstract class PetRepository {
  Future<Map<String, int>> getStats();

  Future<PaginatedPets> listPets({
    PetStatus? status,
    PetSpecies? type,
    String? city,
    String? search,
    int page = 1,
    int pageSize = 20,
  });

  Future<PaginatedPets> searchPets({
    String? query,
    String? breed,
    String? city,
    PetSpecies? type,
    PetStatus? status,
    int page = 1,
    int pageSize = 20,
  });

  Future<Pet> getPetDetail(String id);
  Future<Pet> createReport(ReportInput input);
  Future<Pet> updateReport(String id, ReportInput input);
  Future<void> deleteReport(String id);
}
