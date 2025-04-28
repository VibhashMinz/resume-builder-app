import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/data/models/language_model.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';

class LanguageForm extends StatefulWidget {
  final List<LanguageModel> languages;

  const LanguageForm({super.key, required this.languages});

  @override
  State<LanguageForm> createState() => _LanguageFormState();
}

class _LanguageFormState extends State<LanguageForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _certificationController = TextEditingController();
  LanguageLevel _level = LanguageLevel.beginner;

  @override
  void initState() {
    super.initState();
    if (widget.languages.isNotEmpty) {
      final lastLanguage = widget.languages.last;
      _nameController.text = lastLanguage.name;
      _certificationController.text = lastLanguage.certification ?? '';
      _level = lastLanguage.level;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _certificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.languages.isNotEmpty ? 'Edit Language' : 'Add Language'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final language = LanguageModel(
                  name: _nameController.text,
                  level: _level,
                  certification: _certificationController.text.isNotEmpty ? _certificationController.text : null,
                );
                Navigator.pop(context, [...widget.languages, language]);
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Language Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter language name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<LanguageLevel>(
              value: _level,
              decoration: const InputDecoration(
                labelText: 'Proficiency Level',
                border: OutlineInputBorder(),
              ),
              items: LanguageLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _level = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _certificationController,
              decoration: const InputDecoration(
                labelText: 'Certification (optional)',
                border: OutlineInputBorder(),
                helperText: 'e.g., TOEFL, IELTS, DELF, etc.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
