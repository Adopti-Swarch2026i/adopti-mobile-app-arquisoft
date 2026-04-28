import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasources/remote/matching_api_datasource.dart';
import '../datasources/remote/pets_api_datasource.dart';

class PetRepositoryImpl implements PetRepository {
  final PetsApiDataSource _petsDataSource;
  final MatchingApiDataSource _matchingDataSource;

  PetRepositoryImpl(this._petsDataSource, this._matchingDataSource);

  @override
  Future<Map<String, int>> getStats() async {
    try {
      return await _petsDataSource.getStats();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<PaginatedPets> listPets({
    PetStatus? status,
    PetSpecies? type,
    String? city,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await _petsDataSource.listPets(
        status: status?.name,
        type: type?.name,
        city: city,
        search: search,
        page: page,
        pageSize: pageSize,
      );
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<PaginatedPets> searchPets({
    String? query,
    String? breed,
    String? city,
    PetSpecies? type,
    PetStatus? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await _matchingDataSource.searchPets(
        query: query,
        breed: breed,
        city: city,
        type: type?.name,
        status: status?.name,
        page: page,
        pageSize: pageSize,
      );
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<Pet> getPetDetail(String id) async {
    try {
      final result = await _petsDataSource.getPetDetail(int.parse(id));
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<Pet> createReport(ReportInput input) async {
    try {
      final data = {
        'name': input.name,
        'type': input.type,
        'breed': input.breed,
        'color': input.color,
        'age': input.age,
        'status': input.status.name,
        'location': input.location,
        'city': input.city,
        'description': input.description,
        'owner_phone': input.ownerPhone,
        'image_urls': input.imageUrls,
      };
      final result = await _petsDataSource.createReport(data);
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<Pet> updateReport(String id, ReportInput input) async {
    try {
      final data = {
        'name': input.name,
        'type': input.type,
        'breed': input.breed,
        'color': input.color,
        'age': input.age,
        'status': input.status.name,
        'location': input.location,
        'city': input.city,
        'description': input.description,
        'owner_phone': input.ownerPhone,
        'image_urls': input.imageUrls,
      };
      final result = await _petsDataSource.updateReport(int.parse(id), data);
      return result.toEntity();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> deleteReport(String id) async {
    try {
      await _petsDataSource.deleteReport(int.parse(id));
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
