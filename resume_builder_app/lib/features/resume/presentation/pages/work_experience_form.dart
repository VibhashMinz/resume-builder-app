import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';

class WorkExperienceForm extends StatefulWidget {
  final List<WorkExperience> workExperience;

  const WorkExperienceForm({super.key, required this.workExperience});

  @override
  State<WorkExperienceForm> createState() => _WorkExperienceFormState();
}

class _WorkExperienceFormState extends State<WorkExperienceForm> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _locationController = TextEditingController();
  final _responsibilitiesController = TextEditingController();
  final _achievementsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentlyWorking = false;
  List<WorkExperience> _experiences = [];

  @override
  void initState() {
    super.initState();
    _experiences = List.from(widget.workExperience);
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _locationController.dispose();
    _responsibilitiesController.dispose();
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

  void _addExperience() {
    if (_formKey.currentState!.validate() && _startDate != null) {
      final experience = WorkExperience(
        id: DateTime.now().toIso8601String(),
        company: _companyController.text,
        position: _positionController.text,
        startDate: _startDate!,
        endDate: _isCurrentlyWorking ? null : _endDate,
        location: _locationController.text,
        responsibilities: _responsibilitiesController.text.split('\n').where((line) => line.isNotEmpty).toList(),
        achievements: _achievementsController.text.split('\n').where((line) => line.isNotEmpty).toList(),
      );
      setState(() {
        _experiences.add(experience);
        _clearForm();
      });
    }
  }

  void _clearForm() {
    _companyController.clear();
    _positionController.clear();
    _locationController.clear();
    _responsibilitiesController.clear();
    _achievementsController.clear();
    _startDate = null;
    _endDate = null;
    _isCurrentlyWorking = false;
  }

  void _removeExperience(int index) {
    setState(() {
      _experiences.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Experience'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _experiences);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.amberAccent),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _experiences.length,
              itemBuilder: (context, index) {
                final experience = _experiences[index];
                return ListTile(
                  title: Text(experience.position),
                  subtitle: Text('${experience.company} | ${experience.startDate.year} - ${experience.endDate?.year ?? 'Present'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeExperience(index),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _positionController,
                    decoration: const InputDecoration(
                      labelText: 'Position',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter position';
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
                        child: _isCurrentlyWorking
                            ? CheckboxListTile(
                                title: const Text('Currently Working'),
                                value: _isCurrentlyWorking,
                                onChanged: (value) {
                                  setState(() {
                                    _isCurrentlyWorking = value!;
                                    if (_isCurrentlyWorking) {
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
                    controller: _responsibilitiesController,
                    decoration: const InputDecoration(
                      labelText: 'Responsibilities (one per line)',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one responsibility';
                      }
                      return null;
                    },
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addExperience,
                    child: const Text('Add Experience'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
