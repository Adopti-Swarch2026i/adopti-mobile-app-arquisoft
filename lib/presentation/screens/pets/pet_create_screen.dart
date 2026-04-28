import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/pet.dart';
import '../../../domain/entities/report.dart';
import '../../providers/dependency_injection.dart';

class PetCreateScreen extends ConsumerStatefulWidget {
  const PetCreateScreen({super.key});

  @override
  ConsumerState<PetCreateScreen> createState() => _PetCreateScreenState();
}

class _PetCreateScreenState extends ConsumerState<PetCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  PetStatus _status = PetStatus.lost;
  PetSpecies _species = PetSpecies.dog;
  final List<File> _selectedImages = [];
  final List<String> _uploadedImageUrls = [];
  bool _isLoading = false;
  bool _isUploadingImages = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _breedCtrl.dispose();
    _colorCtrl.dispose();
    _ageCtrl.dispose();
    _locationCtrl.dispose();
    _cityCtrl.dispose();
    _descriptionCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;
    setState(() => _isUploadingImages = true);
    try {
      final mediaRepo = ref.read(mediaRepositoryProvider);
      for (final image in _selectedImages) {
        final result = await mediaRepo.uploadImage(image);
        _uploadedImageUrls.add(result.url);
      }
      _selectedImages.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error subiendo imágenes: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingImages = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Upload any remaining images
      await _uploadImages();

      final input = ReportInput(
        name: _nameCtrl.text.trim(),
        type: _species.name,
        breed: _breedCtrl.text.trim().isEmpty ? null : _breedCtrl.text.trim(),
        color: _colorCtrl.text.trim().isEmpty ? null : _colorCtrl.text.trim(),
        age: _ageCtrl.text.trim().isEmpty ? null : _ageCtrl.text.trim(),
        status: _status,
        location: _locationCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        ownerPhone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        imageUrls: _uploadedImageUrls,
      );

      final repo = ref.read(petRepositoryProvider);
      await repo.createReport(input);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte creado exitosamente')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Reporte')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionTitle('Información básica'),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre *'),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PetSpecies>(
              decoration: const InputDecoration(labelText: 'Especie *'),
              value: _species,
              items: PetSpecies.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(switch (s) {
                    PetSpecies.dog => 'Perro',
                    PetSpecies.cat => 'Gato',
                    PetSpecies.bird => 'Ave',
                    PetSpecies.other => 'Otro',
                  }),
                );
              }).toList(),
              onChanged: (v) => setState(() => _species = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PetStatus>(
              decoration: const InputDecoration(labelText: 'Estado *'),
              value: _status,
              items: PetStatus.values.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text(switch (s) {
                    PetStatus.lost => 'Perdido',
                    PetStatus.found => 'Encontrado',
                    PetStatus.reunited => 'Reunido',
                  }),
                );
              }).toList(),
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _breedCtrl,
              decoration: const InputDecoration(labelText: 'Raza'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _colorCtrl,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ageCtrl,
              decoration: const InputDecoration(labelText: 'Edad'),
            ),
            const SizedBox(height: 24),
            _SectionTitle('Ubicación'),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Ubicación *'),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityCtrl,
              decoration: const InputDecoration(labelText: 'Ciudad *'),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 24),
            _SectionTitle('Descripción'),
            TextFormField(
              controller: _descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción *'),
              maxLines: 4,
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 24),
            _SectionTitle('Contacto'),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Teléfono de contacto'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            _SectionTitle('Imágenes'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._uploadedImageUrls.map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )),
                ..._selectedImages.map((file) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )),
                InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_photo_alternate),
                  ),
                ),
              ],
            ),
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _isUploadingImages ? null : _uploadImages,
                icon: _isUploadingImages
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(_isUploadingImages
                    ? 'Subiendo...'
                    : 'Subir ${_selectedImages.length} imagen(es)'),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Crear Reporte'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
