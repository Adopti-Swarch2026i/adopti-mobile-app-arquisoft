import '../../domain/entities/pet.dart';

class PetModel {
  final int id;
  final String name;
  final String type;
  final String? breed;
  final String? color;
  final String? age;
  final List<String> imageUrls;
  final String? description;
  final String? location;
  final String? city;
  final String? status;
  final String? reporterId;
  final String? reporterName;
  final String? contactPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PetModel({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.color,
    this.age,
    required this.imageUrls,
    this.description,
    this.location,
    this.city,
    this.status,
    this.reporterId,
    this.reporterName,
    this.contactPhone,
    this.createdAt,
    this.updatedAt,
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
        description: json['description'] as String?,
        location: json['location'] as String?,
        city: json['city'] as String?,
        status: json['status'] as String?,
        reporterId: json['reporter_id'] as String? ?? json['owner_id'] as String?,
        reporterName: json['reporter_name'] as String? ?? json['owner_name'] as String?,
        contactPhone: json['contact_phone'] as String? ?? json['owner_phone'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'] as String)
            : null,
      );

  Pet toEntity() => Pet(
        id: id.toString(),
        name: name,
        species: _parseSpecies(type),
        breed: breed ?? '',
        color: color ?? '',
        age: age ?? '',
        description: description ?? '',
        status: _parseStatus(status ?? 'lost'),
        imageUrls: imageUrls,
        location: location ?? '',
        city: city ?? '',
        date: createdAt ?? DateTime.now(),
        reporterId: reporterId ?? '',
        reporterName: reporterName ?? '',
        contactPhone: contactPhone,
        createdAt: createdAt ?? DateTime.now(),
        updatedAt: updatedAt ?? DateTime.now(),
      );

  static PetSpecies _parseSpecies(String value) {
    return PetSpecies.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PetSpecies.other,
    );
  }

  static PetStatus _parseStatus(String value) {
    return PetStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => PetStatus.lost,
    );
  }
}
