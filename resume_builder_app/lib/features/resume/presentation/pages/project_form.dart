import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';

class ProjectForm extends StatefulWidget {
  final List<Project> projects;

  const ProjectForm({super.key, required this.projects});

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _urlController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isOngoing = false;

  @override
  void initState() {
    super.initState();
    if (widget.projects.isNotEmpty) {
      final lastProject = widget.projects.last;
      _titleController.text = lastProject.name;
      _descriptionController.text = lastProject.description;
      _technologiesController.text = lastProject.technologies.join(', ');
      _urlController.text = lastProject.link ?? '';
      _startDate = lastProject.startDate;
      _endDate = lastProject.endDate;
      _isOngoing = lastProject.endDate == null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _urlController.dispose();
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
        title: Text(widget.projects.isNotEmpty ? 'Edit Project' : 'Add Project'),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate() && _startDate != null) {
                final project = Project(
                  id: DateTime.now().toIso8601String(),
                  name: _titleController.text,
                  description: _descriptionController.text,
                  startDate: _startDate!,
                  endDate: _isOngoing ? null : _endDate,
                  technologies: _technologiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                  link: _urlController.text.isNotEmpty ? _urlController.text : null,
                );
                Navigator.pop(context, project);
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
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Project Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter project title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter project description';
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
                  child: _isOngoing
                      ? CheckboxListTile(
                          title: const Text('Ongoing'),
                          value: _isOngoing,
                          onChanged: (value) {
                            setState(() {
                              _isOngoing = value!;
                              if (_isOngoing) {
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
              controller: _technologiesController,
              decoration: const InputDecoration(
                labelText: 'Technologies Used',
                border: OutlineInputBorder(),
                helperText: 'Separate technologies with commas',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter at least one technology';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Project URL (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
          ],
        ),
      ),
    );
  }
}
