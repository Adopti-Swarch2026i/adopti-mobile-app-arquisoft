import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PetCreateScreen extends ConsumerStatefulWidget {
  const PetCreateScreen({super.key});

  @override
  ConsumerState<PetCreateScreen> createState() => _PetCreateScreenState();
}

class _PetCreateScreenState extends ConsumerState<PetCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Reporte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // TODO: submit form
                },
                child: const Text('Crear Reporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
