import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';

class EducationForm extends StatefulWidget {
  final List<Education> education;

  const EducationForm({super.key, required this.education});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _degreeController = TextEditingController();
  final _fieldController = TextEditingController();
  final _locationController = TextEditingController();
  final _gpaController = TextEditingController();
  final _achievementsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentlyStudying = false;

  @override
  void initState() {
    super.initState();
    if (widget.education.isNotEmpty) {
      final lastEducation = widget.education.last;
      _institutionController.text = lastEducation.institution;
      _degreeController.text = lastEducation.degree;
      _fieldController.text = lastEducation.field;
      _locationController.text = lastEducation.location;
      _gpaController.text = lastEducation.gpa?.toString() ?? '';
      _startDate = lastEducation.startDate;
      _endDate = lastEducation.endDate;
      _isCurrentlyStudying = lastEducation.endDate == null;
      _achievementsController.text = lastEducation.achievements.join('\n');
    }
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _locationController.dispose();
    _gpaController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.education.isNotEmpty ? 'Edit Education' : 'Add Education'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _startDate != null) {
                final education = Education(
                  id: widget.education.isNotEmpty ? widget.education.last.id : DateTime.now().toIso8601String(),
                  institution: _institutionController.text,
                  degree: _degreeController.text,
                  field: _fieldController.text,
                  startDate: _startDate!,
                  endDate: _isCurrentlyStudying ? null : _endDate,
                  location: _locationController.text,
                  gpa: double.tryParse(_gpaController.text),
                  achievements: _achievementsController.text.split('\n').where((line) => line.isNotEmpty).toList(),
                );
                Navigator.pop(context, education);
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
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Institution Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter institution name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _degreeController,
              decoration: const InputDecoration(
                labelText: 'Degree',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter degree';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _fieldController,
              decoration: const InputDecoration(
                labelText: 'Field of Study',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter field of study';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _gpaController,
              decoration: const InputDecoration(
                labelText: 'GPA (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final gpa = double.tryParse(value);
                  if (gpa == null || gpa < 0 || gpa > 4.0) {
                    return 'Please enter a valid GPA between 0.0 and 4.0';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Start Date'),
                    subtitle: Text(_startDate == null ? 'Not set' : '${_startDate!.month}/${_startDate!.year}'),
                    onTap: () => _selectDate(context, true),
                  ),
                ),
                Expanded(
                  child: _isCurrentlyStudying
                      ? CheckboxListTile(
                          title: const Text('Currently Studying'),
                          value: _isCurrentlyStudying,
                          onChanged: (value) {
                            setState(() {
                              _isCurrentlyStudying = value!;
                              if (_isCurrentlyStudying) {
                                _endDate = null;
                              }
                            });
                          },
                        )
                      : ListTile(
                          title: const Text('End Date'),
                          subtitle: Text(_endDate == null ? 'Not set' : '${_endDate!.month}/${_endDate!.year}'),
                          onTap: () => _selectDate(context, false),
                        ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _achievementsController,
              decoration: const InputDecoration(
                labelText: 'Achievements (one per line)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
