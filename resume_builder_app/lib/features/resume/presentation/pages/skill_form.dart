import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';

class SkillForm extends StatefulWidget {
  final List<Skill> skills;

  const SkillForm({super.key, required this.skills});

  @override
  State<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends State<SkillForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  SkillLevel _level = SkillLevel.beginner;

  @override
  void initState() {
    super.initState();
    if (widget.skills.isNotEmpty) {
      final lastSkill = widget.skills.last;
      _nameController.text = lastSkill.name;
      _categoryController.text = lastSkill.category;
      _level = lastSkill.level;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.skills.isNotEmpty ? 'Edit Skill' : 'Add Skill'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final skill = Skill(
                  id: DateTime.now().toIso8601String(),
                  name: _nameController.text,
                  category: _categoryController.text,
                  level: _level,
                );
                Navigator.pop(context, [...widget.skills, skill]);
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
                labelText: 'Skill Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter skill name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                helperText: 'e.g., Programming Languages, Frameworks, Tools, etc.',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<SkillLevel>(
              value: _level,
              decoration: const InputDecoration(
                labelText: 'Proficiency Level',
                border: OutlineInputBorder(),
              ),
              items: SkillLevel.values.map((level) {
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
          ],
        ),
      ),
    );
  }
}
