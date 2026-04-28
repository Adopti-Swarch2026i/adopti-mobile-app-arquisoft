import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/pet.dart';
import '../../../domain/entities/report.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/dependency_injection.dart';
import '../../providers/pets_provider.dart';

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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (source == ImageSource.camera) {
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() {
          _selectedImages.add(File(picked.path));
        });
      }
    } else {
      final picked = await picker.pickMultiImage();
      if (picked.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(picked.map((x) => File(x.path)));
        });
      }
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

      ref.invalidate(petListNotifierProvider);

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

  Widget _buildStatusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Tipo de reporte'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                title: 'Perdida',
                subtitle: 'Perdí a mi mascota',
                icon: Icons.warning_amber_rounded,
                color: AppColors.lost,
                isSelected: _status == PetStatus.lost,
                onTap: () => setState(() => _status = PetStatus.lost),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatusCard(
                title: 'Encontrada',
                subtitle: 'Encontré una mascota',
                icon: Icons.check_circle_outline,
                color: AppColors.found,
                isSelected: _status == PetStatus.found,
                onTap: () => setState(() => _status = PetStatus.found),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Reporte'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            _buildStatusSelector(),
            const SizedBox(height: 32),
            
            const _SectionTitle('La mascota'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameCtrl,
              decoration: _inputDecoration('Nombre *'),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PetSpecies>(
              decoration: _inputDecoration('Especie *'),
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _breedCtrl,
                    decoration: _inputDecoration('Raza (opcional)'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _colorCtrl,
                    decoration: _inputDecoration('Color'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ageCtrl,
              decoration: _inputDecoration('Edad aprox. (opcional)'),
            ),
            
            const SizedBox(height: 32),
            const _SectionTitle('Ubicación'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _locationCtrl,
              decoration: _inputDecoration('Barrio o dirección *'),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityCtrl,
              decoration: _inputDecoration('Ciudad *'),
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            
            const SizedBox(height: 32),
            const _SectionTitle('Detalles'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionCtrl,
              decoration: _inputDecoration('Descripción, señas particulares... *'),
              maxLines: 4,
              validator: (v) => v?.trim().isEmpty == true ? 'Requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: _inputDecoration('Teléfono de contacto (opcional)'),
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: 32),
            const _SectionTitle('Fotos'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ..._uploadedImageUrls.map((url) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )),
                ..._selectedImages.map((file) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        file,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )),
                InkWell(
                  onTap: _pickImages,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Icon(Icons.add_photo_alternate, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
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
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Publicar Reporte',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 48),
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
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? color : Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
