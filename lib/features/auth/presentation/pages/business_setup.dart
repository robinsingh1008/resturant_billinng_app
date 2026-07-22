import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resturent_billinng_app/config/routes/app_routes.dart';
import 'package:resturent_billinng_app/widgets/app_button.dart';
import 'package:resturent_billinng_app/widgets/app_phone_field.dart';
import 'package:resturent_billinng_app/widgets/app_text_form.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _imagePicker = ImagePicker();
  XFile? _logoFile;

  void _goBack() {
    context.go(AppRoutes.category);
  }

  void _finishSetup() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.go(AppRoutes.main);
  }

  Future<void> _pickLogo() async {
    final logo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 900,
      maxHeight: 900,
      imageQuality: 85,
    );
    if (logo == null || !mounted) return;
    setState(() => _logoFile = logo);
  }

  void _removeLogo() {
    setState(() => _logoFile = null);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goBack,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create your business',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add the required details to set up billing.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                _FieldLabel(label: 'Cafe logo', isRequired: false),
                _LogoPicker(
                  logoFile: _logoFile,
                  onPickLogo: _pickLogo,
                  onRemoveLogo: _removeLogo,
                ),
                const SizedBox(height: 22),
                _FieldLabel(label: 'Business name'),
                AppTextField(
                  controller: _businessNameController,
                  hintText: 'Restaurant or cafe name',
                  textInputAction: TextInputAction.next,
                  hasBorder: true,
                  borderRadius: 8,
                  validator: _requiredValidator('Business name is required'),
                ),
                const SizedBox(height: 18),
                _FieldLabel(label: 'Owner name'),
                AppTextField(
                  controller: _ownerNameController,
                  hintText: 'Owner full name',
                  textInputAction: TextInputAction.next,
                  hasBorder: true,
                  borderRadius: 8,
                  validator: _requiredValidator('Owner name is required'),
                ),
                const SizedBox(height: 18),
                _FieldLabel(label: 'Business phone number'),
                AppPhoneField(
                  controller: _phoneController,
                  hintText: 'Enter phone number',
                  borderRadius: 8,
                  validator: (value) {
                    final digits = value?.number.replaceAll(RegExp(r'\D'), '');
                    if (digits == null || digits.length < 9) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                _FieldLabel(label: 'Business address'),
                AppTextField(
                  controller: _addressController,
                  hintText: 'Shop number, street, area, city',
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  hasBorder: true,
                  borderRadius: 8,
                  maxsize: 96,
                  validator: _requiredValidator('Business address is required'),
                ),
                const SizedBox(height: 18),
                _FieldLabel(label: 'Pincode'),
                AppTextField(
                  controller: _pincodeController,
                  hintText: '6 digit pincode',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hasBorder: true,
                  borderRadius: 8,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().length != 6) {
                      return 'Valid 6 digit pincode is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                AppButton(
                  key: const ValueKey('finish_setup_button'),
                  buttonText: 'Finish Setup',
                  height: 56,
                  borderRadius: 8,
                  fontWeight: FontWeight.w800,
                  onPressed: _finishSetup,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FormFieldValidator<String> _requiredValidator(String message) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, this.isRequired = true});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        isRequired ? '$label *' : label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _LogoPicker extends StatelessWidget {
  const _LogoPicker({
    required this.logoFile,
    required this.onPickLogo,
    required this.onRemoveLogo,
  });

  final XFile? logoFile;
  final VoidCallback onPickLogo;
  final VoidCallback onRemoveLogo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedLogo = logoFile;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: selectedLogo == null
                ? Icon(
                    Icons.storefront_outlined,
                    color: colorScheme.primary,
                    size: 34,
                  )
                : Image.file(File(selectedLogo.path), fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedLogo == null ? 'Add cafe logo' : 'Logo selected',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedLogo == null
                      ? 'Upload from gallery for bills and branding.'
                      : selectedLogo.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onPickLogo,
                      icon: const Icon(Icons.photo_library_outlined, size: 18),
                      label: Text(selectedLogo == null ? 'Upload' : 'Change'),
                    ),
                    if (selectedLogo != null)
                      TextButton(
                        onPressed: onRemoveLogo,
                        child: const Text('Remove'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
