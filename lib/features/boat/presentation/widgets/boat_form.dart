import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';

class BoatForm extends StatefulWidget {
  final bool isLoading;
  final String? initialBoatName;
  final String? initialRegistrationNumber;
  final String? initialBoatType;
  final double? initialCapacityKg;
  final String? initialEngineNumber;
  final String? initialLicenseNumber;
  final String? initialImageUrl;

  final void Function({
  required String boatName,
  required String registrationNumber,
  required String boatType,
  required double capacityKg,
  required String engineNumber,
  required String licenseNumber,
  required String imagePath,
  }) onSubmit;

  const BoatForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.initialBoatName,
    this.initialRegistrationNumber,
    this.initialBoatType,
    this.initialCapacityKg,
    this.initialEngineNumber,
    this.initialLicenseNumber,
    this.initialImageUrl,
  });

  @override
  State<BoatForm> createState() => _BoatFormState();
}

class _BoatFormState extends State<BoatForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _boatNameController;
  late final TextEditingController _registrationController;
  late final TextEditingController _capacityController;
  late final TextEditingController _engineController;
  late final TextEditingController _licenseController;

  String _boatType = 'Fishing Boat';
  String _imagePath = '';

  @override
  void initState() {
    super.initState();

    _boatNameController = TextEditingController(
      text: widget.initialBoatName ?? '',
    );

    _registrationController = TextEditingController(
      text: widget.initialRegistrationNumber ?? '',
    );

    _capacityController = TextEditingController(
      text: widget.initialCapacityKg?.toString() ?? '',
    );

    _engineController = TextEditingController(
      text: widget.initialEngineNumber ?? '',
    );

    _licenseController = TextEditingController(
      text: widget.initialLicenseNumber ?? '',
    );

    _boatType = widget.initialBoatType ?? 'Fishing Boat';
  }

  @override
  void dispose() {
    _boatNameController.dispose();
    _registrationController.dispose();
    _capacityController.dispose();
    _engineController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _imagePath = image.path;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final capacity =
    double.tryParse(_capacityController.text.trim());

    if (capacity == null || capacity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid boat capacity.'),
        ),
      );
      return;
    }

    widget.onSubmit(
      boatName: _boatNameController.text.trim(),
      registrationNumber:
      _registrationController.text.trim(),
      boatType: _boatType,
      capacityKg: capacity,
      engineNumber: _engineController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      imagePath: _imagePath,
    );
  }

  InputDecoration _decoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.cardBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryBlue,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.cardBorder,
                ),
              ),
              child: _imagePath.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  // ignore: unnecessary_import
                  File(_imagePath),
                  fit: BoxFit.cover,
                ),
              )
                  : widget.initialImageUrl != null &&
                  widget.initialImageUrl!.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.initialImageUrl!,
                  fit: BoxFit.cover,
                ),
              )
                  : const Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 42,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Boat Image',
                    style: TextStyle(
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: _boatNameController,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              'Boat Name',
              Icons.directions_boat_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter boat name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _registrationController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            decoration: _decoration(
              'Registration Number',
              Icons.confirmation_number_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter registration number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _boatType,
            decoration: _decoration(
              'Boat Type',
              Icons.sailing_outlined,
            ),
            items: const [
              DropdownMenuItem(
                value: 'Fishing Boat',
                child: Text('Fishing Boat'),
              ),
              DropdownMenuItem(
                value: 'Trawler',
                child: Text('Trawler'),
              ),
              DropdownMenuItem(
                value: 'Catamaran',
                child: Text('Catamaran'),
              ),
              DropdownMenuItem(
                value: 'Traditional Boat',
                child: Text('Traditional Boat'),
              ),
            ],
            onChanged: widget.isLoading
                ? null
                : (value) {
              if (value == null) return;

              setState(() {
                _boatType = value;
              });
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _capacityController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              'Capacity (KG)',
              Icons.scale_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter boat capacity';
              }

              final capacity = double.tryParse(value);

              if (capacity == null || capacity <= 0) {
                return 'Enter a valid capacity';
              }

              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _engineController,
            textInputAction: TextInputAction.next,
            decoration: _decoration(
              'Engine Number',
              Icons.settings_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter engine number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _licenseController,
            textInputAction: TextInputAction.done,
            decoration: _decoration(
              'Fishing License Number',
              Icons.badge_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter license number';
              }
              return null;
            },
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
                  : const Text('Save Boat'),
            ),
          ),
        ],
      ),
    );
  }
}