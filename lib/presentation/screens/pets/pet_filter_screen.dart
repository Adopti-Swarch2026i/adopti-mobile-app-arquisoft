import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/pet.dart';
import '../../providers/pets_provider.dart';

class PetFilterScreen extends ConsumerStatefulWidget {
  const PetFilterScreen({super.key});

  @override
  ConsumerState<PetFilterScreen> createState() => _PetFilterScreenState();
}

class _PetFilterScreenState extends ConsumerState<PetFilterScreen> {
  late TextEditingController _cityCtrl;
  late TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(activeFiltersProvider);
    _cityCtrl = TextEditingController(text: filters.city ?? '');
    _searchCtrl = TextEditingController(text: filters.search ?? '');
  }

  @override
  void dispose() {
    _cityCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _updateFilters(PetListParams Function(PetListParams current) updater) {
    final current = ref.read(activeFiltersProvider);
    ref.read(activeFiltersProvider.notifier).state = updater(current);
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(activeFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(activeFiltersProvider.notifier).state = const PetListParams();
              _cityCtrl.clear();
              _searchCtrl.clear();
            },
            child: const Text('Limpiar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DropdownFilter<PetStatus>(
            label: 'Estado',
            value: filters.status,
            items: PetStatus.values,
            displayName: (s) => switch (s) {
              PetStatus.lost => 'Perdido',
              PetStatus.found => 'Encontrado',
              PetStatus.reunited => 'Reunido',
            },
            onChanged: (value) => _updateFilters((c) => c.copyWith(status: value)),
          ),
          const SizedBox(height: 16),
          _DropdownFilter<PetSpecies>(
            label: 'Especie',
            value: filters.type,
            items: PetSpecies.values,
            displayName: (s) => switch (s) {
              PetSpecies.dog => 'Perro',
              PetSpecies.cat => 'Gato',
              PetSpecies.bird => 'Ave',
              PetSpecies.other => 'Otro',
            },
            onChanged: (value) => _updateFilters((c) => c.copyWith(type: value)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _cityCtrl,
            decoration: const InputDecoration(
              labelText: 'Ciudad',
              prefixIcon: Icon(Icons.location_city),
            ),
            onChanged: (value) => _updateFilters(
              (c) => c.copyWith(city: value.isEmpty ? null : value),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              labelText: 'Búsqueda',
              prefixIcon: Icon(Icons.search),
              hintText: 'Nombre, raza...',
            ),
            onChanged: (value) => _updateFilters(
              (c) => c.copyWith(search: value.isEmpty ? null : value),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.pop(),
              child: const Text('Aplicar filtros'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownFilter<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) displayName;
  final ValueChanged<T?> onChanged;

  const _DropdownFilter({
    required this.label,
    required this.value,
    required this.items,
    required this.displayName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(labelText: label),
      value: value,
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('Todos'),
        ),
        ...items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(displayName(item)),
            )),
      ],
      onChanged: onChanged,
    );
  }
}
