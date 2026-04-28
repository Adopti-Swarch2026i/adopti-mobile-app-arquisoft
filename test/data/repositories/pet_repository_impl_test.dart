import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:adopti_mobile/core/errors/exceptions.dart';
import 'package:adopti_mobile/core/errors/failures.dart';
import 'package:adopti_mobile/data/datasources/remote/matching_api_datasource.dart';
import 'package:adopti_mobile/data/datasources/remote/pets_api_datasource.dart';
import 'package:adopti_mobile/data/models/paginated_reports_model.dart';
import 'package:adopti_mobile/data/models/pet_model.dart';
import 'package:adopti_mobile/data/models/report_response_model.dart';
import 'package:adopti_mobile/data/repositories/pet_repository_impl.dart';
import 'package:adopti_mobile/domain/entities/pet.dart';
import 'package:adopti_mobile/domain/entities/report.dart';

class MockPetsApiDataSource extends Mock implements PetsApiDataSource {}

class MockMatchingApiDataSource extends Mock implements MatchingApiDataSource {}

void main() {
  late PetRepositoryImpl repository;
  late MockPetsApiDataSource petsApi;
  late MockMatchingApiDataSource matchingApi;

  setUp(() {
    petsApi = MockPetsApiDataSource();
    matchingApi = MockMatchingApiDataSource();
    repository = PetRepositoryImpl(petsApi, matchingApi);
  });

  group('getStats', () {
    test('returns stats map on success', () async {
      when(() => petsApi.getStats()).thenAnswer(
        (_) async => {'lost': 5, 'found': 3, 'reunited': 2},
      );

      final result = await repository.getStats();

      expect(result['lost'], equals(5));
      expect(result['found'], equals(3));
      expect(result['reunited'], equals(2));
      verify(() => petsApi.getStats()).called(1);
    });

    test('throws ServerFailure on exception', () async {
      when(() => petsApi.getStats()).thenThrow(
        ServerException('network error'),
      );

      expect(() => repository.getStats(), throwsA(isA<Failure>()));
    });
  });

  group('getPetDetail', () {
    test('returns Pet entity on success', () async {
      final reportModel = ReportResponseModel(
        id: 1,
        status: 'lost',
        location: 'Park',
        city: 'Bogotá',
        description: 'Friendly dog',
        ownerId: 'user-1',
        createdAt: DateTime(2026, 4, 1),
        pet: PetModel(
          id: 1,
          name: 'Luna',
          type: 'dog',
          imageUrls: const [],
        ),
      );

      when(() => petsApi.getPetDetail(1)).thenAnswer((_) async => reportModel);

      final result = await repository.getPetDetail('1');

      expect(result.name, equals('Luna'));
      expect(result.status, equals(PetStatus.lost));
      expect(result.city, equals('Bogotá'));
    });
  });

  group('createReport', () {
    test('returns created Pet on success', () async {
      final input = ReportInput(
        name: 'Michi',
        type: 'cat',
        status: PetStatus.found,
        location: 'Street 123',
        city: 'Medellín',
        description: 'Black cat',
        imageUrls: const [],
      );

      final reportModel = ReportResponseModel(
        id: 2,
        status: 'found',
        location: 'Street 123',
        city: 'Medellín',
        description: 'Black cat',
        ownerId: 'user-2',
        createdAt: DateTime(2026, 4, 2),
        pet: PetModel(
          id: 2,
          name: 'Michi',
          type: 'cat',
          imageUrls: const [],
        ),
      );

      when(() => petsApi.createReport(any())).thenAnswer((_) async => reportModel);

      final result = await repository.createReport(input);

      expect(result.name, equals('Michi'));
      expect(result.status, equals(PetStatus.found));
    });
  });

  group('searchPets', () {
    test('delegates to matching api and returns PaginatedPets', () async {
      final paginatedModel = PaginatedReportsModel(
        total: 1,
        page: 1,
        pageSize: 20,
        results: [
          ReportResponseModel(
            id: 3,
            status: 'lost',
            location: 'Park',
            city: 'Cali',
            description: 'Small dog',
            ownerId: 'user-3',
            createdAt: DateTime(2026, 4, 3),
            pet: PetModel(
              id: 3,
              name: 'Rocky',
              type: 'dog',
              imageUrls: const [],
            ),
          ),
        ],
      );

      when(() => matchingApi.searchPets(
            query: any(named: 'query'),
            breed: any(named: 'breed'),
            city: any(named: 'city'),
            type: any(named: 'type'),
            status: any(named: 'status'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => paginatedModel);

      final result = await repository.searchPets(query: 'rocky');

      expect(result.total, equals(1));
      expect(result.results.first.name, equals('Rocky'));
    });
  });
}
