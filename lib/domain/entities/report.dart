import 'pet.dart';

class ReportInput {
  final String name;
  final String type;
  final String? breed;
  final String? color;
  final String? age;
  final PetStatus status;
  final String location;
  final String city;
  final String description;
  final String? ownerPhone;
  final List<String> imageUrls;

  const ReportInput({
    required this.name,
    required this.type,
    this.breed,
    this.color,
    this.age,
    required this.status,
    required this.location,
    required this.city,
    required this.description,
    this.ownerPhone,
    required this.imageUrls,
  });
}
