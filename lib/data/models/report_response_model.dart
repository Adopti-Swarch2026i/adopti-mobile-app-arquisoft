import '../../domain/entities/pet.dart';
import 'pet_model.dart';

class ReportResponseModel {
  final int id;
  final String status;
  final String location;
  final String city;
  final String description;
  final String? ownerName;
  final String? ownerPhone;
  final String ownerId;
  final DateTime createdAt;
  final PetModel pet;

  const ReportResponseModel({
    required this.id,
    required this.status,
    required this.location,
    required this.city,
    required this.description,
    this.ownerName,
    this.ownerPhone,
    required this.ownerId,
    required this.createdAt,
    required this.pet,
  });

  factory ReportResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportResponseModel(
      id: json['id'] as int,
      status: json['status'] as String,
      location: json['location'] as String,
      city: json['city'] as String,
      description: json['description'] as String,
      ownerName: json['owner_name'] as String?,
      ownerPhone: json['owner_phone'] as String?,
      ownerId: json['owner_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      pet: PetModel.fromJson(json['pet'] as Map<String, dynamic>),
    );
  }

  Pet toEntity() => Pet(
        id: pet.id.toString(),
        name: pet.name,
        species: _parseSpecies(pet.type),
        breed: pet.breed ?? '',
        color: pet.color ?? '',
        age: pet.age ?? '',
        description: description,
        status: _parseStatus(status),
        imageUrls: pet.imageUrls,
        location: location,
        city: city,
        date: createdAt,
        reporterId: ownerId,
        reporterName: ownerName ?? '',
        contactPhone: ownerPhone,
        createdAt: createdAt,
        updatedAt: createdAt,
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
