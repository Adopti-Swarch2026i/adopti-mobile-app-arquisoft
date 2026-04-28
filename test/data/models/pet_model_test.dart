import 'package:flutter_test/flutter_test.dart';
import 'package:adopti_mobile/data/models/pet_model.dart';
import 'package:adopti_mobile/domain/entities/pet.dart';

void main() {
  group('PetModel', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 1,
        'name': 'Luna',
        'type': 'dog',
        'breed': 'Labrador',
        'color': 'Golden',
        'age': '2 years',
        'image_urls': ['https://example.com/luna.jpg'],
        'description': 'Very friendly',
        'location': 'Central Park',
        'city': 'Bogotá',
        'status': 'lost',
        'reporter_id': 'user-123',
        'reporter_name': 'Juan',
        'contact_phone': '3001234567',
        'created_at': '2026-04-01T10:00:00Z',
        'updated_at': '2026-04-02T10:00:00Z',
      };

      final model = PetModel.fromJson(json);

      expect(model.id, equals(1));
      expect(model.name, equals('Luna'));
      expect(model.type, equals('dog'));
      expect(model.breed, equals('Labrador'));
      expect(model.color, equals('Golden'));
      expect(model.age, equals('2 years'));
      expect(model.imageUrls, equals(['https://example.com/luna.jpg']));
      expect(model.description, equals('Very friendly'));
      expect(model.location, equals('Central Park'));
      expect(model.city, equals('Bogotá'));
      expect(model.status, equals('lost'));
      expect(model.reporterId, equals('user-123'));
      expect(model.reporterName, equals('Juan'));
      expect(model.contactPhone, equals('3001234567'));
      expect(model.createdAt, isNotNull);
      expect(model.updatedAt, isNotNull);
    });

    test('toEntity maps all fields without data loss', () {
      final model = PetModel(
        id: 1,
        name: 'Luna',
        type: 'dog',
        breed: 'Labrador',
        color: 'Golden',
        age: '2 years',
        imageUrls: const ['https://example.com/luna.jpg'],
        description: 'Very friendly',
        location: 'Central Park',
        city: 'Bogotá',
        status: 'lost',
        reporterId: 'user-123',
        reporterName: 'Juan',
        contactPhone: '3001234567',
        createdAt: DateTime(2026, 4, 1),
        updatedAt: DateTime(2026, 4, 2),
      );

      final entity = model.toEntity();

      expect(entity.id, equals('1'));
      expect(entity.name, equals('Luna'));
      expect(entity.species, equals(PetSpecies.dog));
      expect(entity.breed, equals('Labrador'));
      expect(entity.color, equals('Golden'));
      expect(entity.age, equals('2 years'));
      expect(entity.description, equals('Very friendly'));
      expect(entity.status, equals(PetStatus.lost));
      expect(entity.imageUrls, equals(['https://example.com/luna.jpg']));
      expect(entity.location, equals('Central Park'));
      expect(entity.city, equals('Bogotá'));
      expect(entity.reporterId, equals('user-123'));
      expect(entity.reporterName, equals('Juan'));
      expect(entity.contactPhone, equals('3001234567'));
      expect(entity.createdAt, equals(DateTime(2026, 4, 1)));
      expect(entity.updatedAt, equals(DateTime(2026, 4, 2)));
    });

    test('toEntity uses defaults for missing optional fields', () {
      final model = PetModel(
        id: 2,
        name: 'Michi',
        type: 'cat',
        imageUrls: const [],
      );

      final entity = model.toEntity();

      expect(entity.breed, equals(''));
      expect(entity.color, equals(''));
      expect(entity.age, equals(''));
      expect(entity.description, equals(''));
      expect(entity.location, equals(''));
      expect(entity.city, equals(''));
      expect(entity.status, equals(PetStatus.lost));
    });

    test('parseSpecies falls back to other for unknown values', () {
      final model = PetModel(
        id: 3,
        name: 'Unknown',
        type: 'dragon',
        imageUrls: const [],
      );

      final entity = model.toEntity();
      expect(entity.species, equals(PetSpecies.other));
    });
  });
}
