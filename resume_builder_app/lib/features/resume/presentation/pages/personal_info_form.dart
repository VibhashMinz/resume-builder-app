import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';

class PersonalInfoForm extends StatefulWidget {
  final PersonalInfo? personalInfo;

  const PersonalInfoForm({super.key, this.personalInfo});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _githubController = TextEditingController();
  final _websiteController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.personalInfo != null) {
      _firstNameController.text = widget.personalInfo!.firstName;
      _lastNameController.text = widget.personalInfo!.lastName;
      _emailController.text = widget.personalInfo!.email;
      _phoneController.text = widget.personalInfo!.phone;
      _addressController.text = widget.personalInfo!.address;
      _cityController.text = widget.personalInfo!.city;
      _stateController.text = widget.personalInfo!.state;
      _countryController.text = widget.personalInfo!.country;
      _zipCodeController.text = widget.personalInfo!.zipCode;
      _linkedInController.text = widget.personalInfo!.linkedIn;
      _githubController.text = widget.personalInfo!.github;
      _websiteController.text = widget.personalInfo!.website;
      _summaryController.text = widget.personalInfo!.summary;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _zipCodeController.dispose();
    _linkedInController.dispose();
    _githubController.dispose();
    _websiteController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]+$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateUrl(String? value) {
    if (value != null && value.isNotEmpty) {
      final urlRegex = RegExp(r'^https?:\/\/[\w\-]+(\.[\w\-]+)+[/#?]?.*$');
      if (!urlRegex.hasMatch(value)) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personalInfo == null ? 'Add Personal Information' : 'Edit Personal Information'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final personalInfo = PersonalInfo(
                  id: widget.personalInfo?.id ?? '',
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  address: _addressController.text,
                  city: _cityController.text,
                  state: _stateController.text,
                  country: _countryController.text,
                  zipCode: _zipCodeController.text,
                  linkedIn: _linkedInController.text,
                  github: _githubController.text,
                  website: _websiteController.text,
                  summary: _summaryController.text,
                );
                Navigator.pop(context, personalInfo);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: _validatePhone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(
                      labelText: 'State/Province',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter state';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter country';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _zipCodeController,
                    decoration: const InputDecoration(
                      labelText: 'ZIP/Postal Code',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ZIP code';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _linkedInController,
              decoration: const InputDecoration(
                labelText: 'LinkedIn URL (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: _validateUrl,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _githubController,
              decoration: const InputDecoration(
                labelText: 'GitHub URL (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: _validateUrl,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _websiteController,
              decoration: const InputDecoration(
                labelText: 'Website URL (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              validator: _validateUrl,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Professional Summary',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a professional summary';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
