import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetFilterScreen extends ConsumerWidget {
  const PetFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filtros')),
      body: const Center(child: Text('PetFilterScreen - TODO')),
    );
  }
}
