enum PetSpecies { dog, cat, bird, other }

enum PetStatus { lost, found, reunited }

class Pet {
  final String id;
  final String name;
  final PetSpecies species;
  final String breed;
  final String color;
  final String age;
  final String description;
  final PetStatus status;
  final List<String> imageUrls;
  final String location;
  final String city;
  final DateTime date;
  final String reporterId;
  final String reporterName;
  final String? contactPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.color,
    required this.age,
    required this.description,
    required this.status,
    required this.imageUrls,
    required this.location,
    required this.city,
    required this.date,
    required this.reporterId,
    required this.reporterName,
    this.contactPhone,
    required this.createdAt,
    required this.updatedAt,
  });
}
