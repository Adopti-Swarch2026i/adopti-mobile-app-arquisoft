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
              labelText: 'Busqueda',
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

  Future<void> _showPicker(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final result = await showModalBottomSheet<T?>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.clear_all,
                color: value == null
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              title: Text(
                'Todos',
                style: TextStyle(
                  fontWeight: value == null ? FontWeight.bold : FontWeight.normal,
                  color: value == null ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              trailing: value == null
                  ? Icon(Icons.check_circle, color: colorScheme.primary)
                  : null,
              onTap: () => Navigator.pop(context, null),
            ),
            ...items.map((item) {
              final isSelected = value == item;
              return ListTile(
                title: Text(
                  displayName(item),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: colorScheme.primary)
                    : null,
                onTap: () => Navigator.pop(context, item),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
    onChanged(result);
  }

  String get _displayValue {
    if (value == null) return 'Todos';
    return displayName(value as T);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPicker(context),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _displayValue,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
