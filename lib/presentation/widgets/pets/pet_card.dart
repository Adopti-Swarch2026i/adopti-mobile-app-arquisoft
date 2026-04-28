import 'package:flutter/material.dart';

import '../../../domain/entities/pet.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({super.key, required this.pet, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: pet.imageUrls.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(pet.imageUrls.first),
              )
            : const CircleAvatar(child: Icon(Icons.pets)),
        title: Text(pet.name),
        subtitle: Text('${pet.status.name} - ${pet.city}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
