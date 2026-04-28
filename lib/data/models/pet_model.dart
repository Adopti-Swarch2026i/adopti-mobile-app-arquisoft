import '../../domain/entities/pet.dart';

class PetModel {
  final int id;
  final String name;
  final String type;
  final String? breed;
  final String? color;
  final String? age;
  final List<String> imageUrls;

  const PetModel({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.color,
    this.age,
    required this.imageUrls,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        id: json['id'] as int,
        name: json['name'] as String,
        type: json['type'] as String,
        breed: json['breed'] as String?,
        color: json['color'] as String?,
        age: json['age'] as String?,
        imageUrls: (json['image_urls'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  Pet toEntity() => Pet(
        id: id.toString(),
        name: name,
        species: _parseSpecies(type),
        breed: breed ?? '',
        color: color ?? '',
        age: age ?? '',
        description: '',
        status: PetStatus.lost,
        imageUrls: imageUrls,
        location: '',
        city: '',
        date: DateTime.now(),
        reporterId: '',
        reporterName: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static PetSpecies _parseSpecies(String value) {
    return PetSpecies.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PetSpecies.other,
    );
  }
}
