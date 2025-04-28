import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_section_model.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_section_bloc.dart';

class SectionEditor extends StatefulWidget {
  final String section;
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;
  final Function(Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>) onUpdate;

  const SectionEditor({
    super.key,
    required this.section,
    required this.resume,
    required this.onUpdate,
  });

  @override
  State<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends State<SectionEditor> {
  final _formKey = GlobalKey<FormState>();
  final _workExperienceFormKey = GlobalKey<FormState>();
  final _educationFormKey = GlobalKey<FormState>();
  final _projectFormKey = GlobalKey<FormState>();
  late Resume _resume;
  late final TextEditingController _summaryController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _linkedInController;
  late final TextEditingController _githubController;
  late final TextEditingController _websiteController;
  late final TextEditingController _companyController;
  late final TextEditingController _positionController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _achievementsController;
  late final TextEditingController _schoolController;
  late final TextEditingController _degreeController;
  late final TextEditingController _fieldController;
  late final TextEditingController _gpaController;
  late final TextEditingController _projectNameController;
  late final TextEditingController _projectDescriptionController;
  late final TextEditingController _projectTechnologiesController;
  late final TextEditingController _projectLinkController;
  late final TextEditingController _skillController;
  late final TextEditingController _languageNameController;
  late final TextEditingController _certificateNameController;
  late final TextEditingController _issuingOrganizationController;
  late final TextEditingController _issueDateController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _credentialIdController;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrentlyWorking = false;
  List<Skill> _skills = [];
  List<Language> _languages = [];
  List<Certificate> _certificates = [];
  String _selectedLevel = LanguageLevel.intermediate.toString().split('.').last;

  @override
  void initState() {
    super.initState();
    _resume = widget.resume;
    _summaryController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _countryController = TextEditingController();
    _zipCodeController = TextEditingController();
    _linkedInController = TextEditingController();
    _githubController = TextEditingController();
    _websiteController = TextEditingController();
    _companyController = TextEditingController();
    _positionController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();
    _achievementsController = TextEditingController();
    _schoolController = TextEditingController();
    _degreeController = TextEditingController();
    _fieldController = TextEditingController();
    _gpaController = TextEditingController();
    _projectNameController = TextEditingController();
    _projectDescriptionController = TextEditingController();
    _projectTechnologiesController = TextEditingController();
    _projectLinkController = TextEditingController();
    _skillController = TextEditingController();
    _languageNameController = TextEditingController();
    _certificateNameController = TextEditingController();
    _issuingOrganizationController = TextEditingController();
    _issueDateController = TextEditingController();
    _expiryDateController = TextEditingController();
    _credentialIdController = TextEditingController();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (_resume.personalInfo != null) {
      _firstNameController.text = _resume.personalInfo!.firstName;
      _lastNameController.text = _resume.personalInfo!.lastName;
      _emailController.text = _resume.personalInfo!.email;
      _phoneController.text = _resume.personalInfo!.phone;
      _addressController.text = _resume.personalInfo!.address;
      _cityController.text = _resume.personalInfo!.city;
      _stateController.text = _resume.personalInfo!.state;
      _countryController.text = _resume.personalInfo!.country;
      _zipCodeController.text = _resume.personalInfo!.zipCode;
      _linkedInController.text = _resume.personalInfo!.linkedIn ?? '';
      _githubController.text = _resume.personalInfo!.github ?? '';
      _websiteController.text = _resume.personalInfo!.website ?? '';
    }

    _summaryController.text = _resume.summary;

    if (_resume.workExperience.isNotEmpty) {
      final lastExperience = _resume.workExperience.last;
      _companyController.text = lastExperience.company;
      _positionController.text = lastExperience.position;
      _locationController.text = lastExperience.location;
      _descriptionController.text = lastExperience.responsibilities.join('\n');
      _achievementsController.text = lastExperience.achievements.join('\n');
      _startDate = lastExperience.startDate;
      _endDate = lastExperience.endDate;
      _isCurrentlyWorking = lastExperience.endDate == null;
    }

    if (_resume.education.isNotEmpty) {
      final lastEducation = _resume.education.last;
      _schoolController.text = lastEducation.institution;
      _degreeController.text = lastEducation.degree;
      _fieldController.text = lastEducation.field;
      _locationController.text = lastEducation.location;
      _gpaController.text = lastEducation.gpa?.toString() ?? '';
      _achievementsController.text = lastEducation.achievements.join('\n');
      _startDate = lastEducation.startDate;
      _endDate = lastEducation.endDate;
      _isCurrentlyWorking = lastEducation.endDate == null;
    }

    if (_resume.projects.isNotEmpty) {
      final lastProject = _resume.projects.last;
      _projectNameController.text = lastProject.name;
      _projectDescriptionController.text = lastProject.description;
      _projectTechnologiesController.text = lastProject.technologies.join(', ');
      _projectLinkController.text = lastProject.link ?? '';
      _startDate = lastProject.startDate;
      _endDate = lastProject.endDate;
    }

    _skills = List.from(_resume.skills);
    _languages = List.from(_resume.languages);
    _certificates = List.from(_resume.certificates);
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
    _companyController.dispose();
    _positionController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _achievementsController.dispose();
    _schoolController.dispose();
    _degreeController.dispose();
    _fieldController.dispose();
    _gpaController.dispose();
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    _projectTechnologiesController.dispose();
    _projectLinkController.dispose();
    _skillController.dispose();
    _languageNameController.dispose();
    _certificateNameController.dispose();
    _issuingOrganizationController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _credentialIdController.dispose();
    super.dispose();
  }

  void _updateResume(Resume updatedResume) {
    setState(() {
      _resume = updatedResume;
    });

    // Create or update the section in Firestore
    final sectionData = _getSectionData();
    if (sectionData != null) {
      final section = ResumeSectionModel(
        id: DateTime.now().toString(),
        resumeId: _resume.id,
        userId: _resume.userId,
        sectionType: widget.section,
        data: sectionData,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Use GetIt to access the bloc instead of context
      GetIt.I<ResumeSectionBloc>().add(CreateResumeSection(section));
    }

    widget.onUpdate(updatedResume);
  }

  Map<String, dynamic>? _getSectionData() {
    switch (widget.section) {
      case 'personal_info':
        return {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'country': _countryController.text,
          'zipCode': _zipCodeController.text,
          'linkedIn': _linkedInController.text,
          'github': _githubController.text,
          'website': _websiteController.text,
        };
      case 'summary':
        return {
          'summary': _summaryController.text,
        };
      case 'work_experience':
        return {
          'company': _companyController.text,
          'position': _positionController.text,
          'location': _locationController.text,
          'responsibilities': _descriptionController.text.split('\n').where((s) => s.isNotEmpty).toList(),
          'achievements': _achievementsController.text.split('\n').where((s) => s.isNotEmpty).toList(),
          'startDate': _startDate?.toIso8601String(),
          'endDate': _endDate?.toIso8601String(),
          'isCurrentlyWorking': _isCurrentlyWorking,
        };
      case 'education':
        return {
          'institution': _schoolController.text,
          'degree': _degreeController.text,
          'field': _fieldController.text,
          'location': _locationController.text,
          'gpa': double.tryParse(_gpaController.text),
          'achievements': _achievementsController.text.split('\n').where((s) => s.isNotEmpty).toList(),
          'startDate': _startDate?.toIso8601String(),
          'endDate': _endDate?.toIso8601String(),
          'isCurrentlyStudying': _isCurrentlyWorking,
        };
      case 'projects':
        return {
          'name': _projectNameController.text,
          'description': _projectDescriptionController.text,
          'technologies': _projectTechnologiesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
          'link': _projectLinkController.text.isEmpty ? null : _projectLinkController.text,
          'startDate': _startDate?.toIso8601String(),
          'endDate': _endDate?.toIso8601String(),
        };
      case 'skills':
        return {
          'skills': _skills
              .map((skill) => {
                    'id': skill.id,
                    'name': skill.name,
                    'level': skill.level.toString(),
                    'category': skill.category,
                  })
              .toList(),
        };
      case 'languages':
        return {
          'languages': _languages
              .map((language) => {
                    'name': language.name,
                    'level': language.level.toString(),
                  })
              .toList(),
        };
      case 'certificates':
        return {
          'certificates': _certificates
              .map((certificate) => {
                    'id': certificate.id,
                    'name': certificate.name,
                    'issuer': certificate.issuer,
                    'issueDate': certificate.issueDate.toIso8601String(),
                    'expiryDate': certificate.expiryDate?.toIso8601String(),
                    'credentialId': certificate.credentialId,
                  })
              .toList(),
        };
      default:
        return null;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _selectProjectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  Future<void> _selectEducationDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skills.add(Skill(
          id: DateTime.now().toString(),
          name: _skillController.text,
          level: SkillLevel.intermediate,
          category: 'Technical',
        ));
        _skillController.clear();
        _updateResume(_resume.copyWith(skills: _skills));
      });
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
      _updateResume(_resume.copyWith(skills: _skills));
    });
  }

  void _addLanguage() {
    if (_languageNameController.text.isNotEmpty) {
      setState(() {
        _languages.add(Language(
          name: _languageNameController.text,
          level: LanguageLevel.values.firstWhere(
            (level) => level.toString().split('.').last == _selectedLevel,
          ),
        ));
        _languageNameController.clear();
        _updateResume(_resume.copyWith(languages: _languages));
      });
    }
  }

  void _removeLanguage(int index) {
    setState(() {
      _languages.removeAt(index);
      _updateResume(_resume.copyWith(languages: _languages));
    });
  }

  void _addCertificate() {
    if (_certificateNameController.text.isNotEmpty) {
      setState(() {
        _certificates.add(Certificate(
          id: DateTime.now().toString(),
          name: _certificateNameController.text,
          issuer: _issuingOrganizationController.text,
          issueDate: DateTime.tryParse(_issueDateController.text) ?? DateTime.now(),
          expiryDate: DateTime.tryParse(_expiryDateController.text),
          credentialId: _credentialIdController.text,
        ));
        _certificateNameController.clear();
        _issuingOrganizationController.clear();
        _issueDateController.clear();
        _expiryDateController.clear();
        _credentialIdController.clear();
        _updateResume(_resume.copyWith(certificates: _certificates));
      });
    }
  }

  void _removeCertificate(int index) {
    setState(() {
      _certificates.removeAt(index);
      _updateResume(_resume.copyWith(certificates: _certificates));
    });
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      switch (widget.section) {
        case 'personal_info':
          final personalInfo = PersonalInfo(
            id: _resume.personalInfo.id,
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
            summary: _resume.personalInfo.summary,
          );
          _updateResume(_resume.copyWith(personalInfo: personalInfo));
          break;
        case 'summary':
          _updateResume(_resume.copyWith(summary: _summaryController.text));
          break;
        case 'work_experience':
          // Work experience is now handled in the _showWorkExperienceEditor method
          // This case is kept for backward compatibility
          break;
        case 'education':
          // Education is now handled in the _showEducationEditor method
          // This case is kept for backward compatibility
          break;
        case 'projects':
          // Projects is now handled in the _showProjectEditor method
          // This case is kept for backward compatibility
          break;
        case 'skills':
          _updateResume(_resume.copyWith(skills: _skills));
          break;
        case 'languages':
          _updateResume(_resume.copyWith(languages: _languages));
          break;
        case 'certificates':
          _updateResume(_resume.copyWith(certificates: _certificates));
          break;
      }
    }
  }

  Widget _buildPersonalInfoForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: const InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
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
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
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
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'ZIP Code',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _linkedInController,
          decoration: const InputDecoration(
            labelText: 'LinkedIn Profile',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _githubController,
          decoration: const InputDecoration(
            labelText: 'GitHub Profile',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _websiteController,
          decoration: const InputDecoration(
            labelText: 'Personal Website',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: _summaryController,
        maxLines: 5,
        decoration: const InputDecoration(
          labelText: 'Professional Summary',
          hintText: 'Write a brief summary of your professional background and career objectives',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildWorkExperienceForm() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _resume.workExperience.length + 1,
            itemBuilder: (context, index) {
              if (index == _resume.workExperience.length) {
                return ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _companyController.clear();
                      _positionController.clear();
                      _locationController.clear();
                      _descriptionController.clear();
                      _achievementsController.clear();
                      _startDate = null;
                      _endDate = null;
                      _isCurrentlyWorking = false;
                    });
                    _showWorkExperienceEditor();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Work Experience'),
                );
              }

              final experience = _resume.workExperience[index];
              return Card(
                child: ListTile(
                  title: Text(experience.position),
                  subtitle: Text(
                      '${experience.company}\n${experience.startDate?.month ?? ''}/${experience.startDate?.year ?? ''} - ${experience.endDate == null ? 'Present' : '${experience.endDate!.month}/${experience.endDate!.year}'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _companyController.text = experience.company;
                            _positionController.text = experience.position;
                            _locationController.text = experience.location;
                            _descriptionController.text = experience.responsibilities.join('\n');
                            _achievementsController.text = experience.achievements.join('\n');
                            _startDate = experience.startDate;
                            _endDate = experience.endDate;
                            _isCurrentlyWorking = experience.endDate == null;
                          });
                          _showWorkExperienceEditor(existingExperience: experience);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            final updatedExperience = List<WorkExperience>.from(_resume.workExperience)..removeAt(index);
                            _updateResume(_resume.copyWith(workExperience: updatedExperience));
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showWorkExperienceEditor({WorkExperience? existingExperience}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _workExperienceFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingExperience == null ? 'Add Work Experience' : 'Edit Work Experience',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
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
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Responsibilities (one per line)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _achievementsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Achievements (one per line)',
                    border: OutlineInputBorder(),
                  ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_workExperienceFormKey.currentState?.validate() ?? false) {
                          final experience = WorkExperience(
                            id: existingExperience?.id ?? DateTime.now().toString(),
                            company: _companyController.text,
                            position: _positionController.text,
                            location: _locationController.text,
                            responsibilities: _descriptionController.text.split('\n').where((s) => s.isNotEmpty).toList(),
                            achievements: _achievementsController.text.split('\n').where((s) => s.isNotEmpty).toList(),
                            startDate: _startDate!,
                            endDate: _isCurrentlyWorking ? null : _endDate,
                          );

                          if (existingExperience != null) {
                            final index = _resume.workExperience.indexWhere((e) => e.id == existingExperience.id);
                            if (index != -1) {
                              final updatedExperience = List<WorkExperience>.from(_resume.workExperience);
                              updatedExperience[index] = experience;
                              _updateResume(_resume.copyWith(workExperience: updatedExperience));
                            }
                          } else {
                            final updatedExperience = List<WorkExperience>.from(_resume.workExperience)..add(experience);
                            _updateResume(_resume.copyWith(workExperience: updatedExperience));
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(existingExperience == null ? 'Add' : 'Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEducationForm() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _resume.education.length + 1,
            itemBuilder: (context, index) {
              if (index == _resume.education.length) {
                return ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _schoolController.clear();
                      _degreeController.clear();
                      _fieldController.clear();
                      _locationController.clear();
                      _gpaController.clear();
                      _achievementsController.clear();
                      _startDate = null;
                      _endDate = null;
                      _isCurrentlyWorking = false;
                    });
                    _showEducationEditor();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Education'),
                );
              }

              final education = _resume.education[index];
              return Card(
                child: ListTile(
                  title: Text(education.degree),
                  subtitle: Text(
                      '${education.institution}\n${education.startDate?.month ?? ''}/${education.startDate?.year ?? ''} - ${education.endDate == null ? 'Present' : '${education.endDate!.month}/${education.endDate!.year}'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _schoolController.text = education.institution;
                            _degreeController.text = education.degree;
                            _fieldController.text = education.field;
                            _locationController.text = education.location;
                            _gpaController.text = education.gpa?.toString() ?? '';
                            _achievementsController.text = education.achievements.join('\n');
                            _startDate = education.startDate;
                            _endDate = education.endDate;
                            _isCurrentlyWorking = education.endDate == null;
                          });
                          _showEducationEditor(existingEducation: education);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            final updatedEducation = List<Education>.from(_resume.education)..removeAt(index);
                            _updateResume(_resume.copyWith(education: updatedEducation));
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showEducationEditor({Education? existingEducation}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _educationFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingEducation == null ? 'Add Education' : 'Edit Education',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _schoolController,
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
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _gpaController,
                  decoration: const InputDecoration(
                    labelText: 'GPA (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _achievementsController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Achievements (one per line)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Start Date'),
                        subtitle: Text(_startDate == null ? 'Not set' : '${_startDate!.month}/${_startDate!.year}'),
                        onTap: () => _selectEducationDate(context, true),
                      ),
                    ),
                    Expanded(
                      child: _isCurrentlyWorking
                          ? CheckboxListTile(
                              title: const Text('Currently Studying'),
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
                              onTap: () => _selectEducationDate(context, false),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_educationFormKey.currentState?.validate() ?? false) {
                          final education = Education(
                            id: existingEducation?.id ?? DateTime.now().toString(),
                            institution: _schoolController.text,
                            degree: _degreeController.text,
                            field: _fieldController.text,
                            location: _locationController.text,
                            gpa: double.tryParse(_gpaController.text),
                            achievements: _achievementsController.text.split('\n').where((s) => s.isNotEmpty).toList(),
                            startDate: _startDate!,
                            endDate: _isCurrentlyWorking ? null : _endDate,
                          );

                          if (existingEducation != null) {
                            final index = _resume.education.indexWhere((e) => e.id == existingEducation.id);
                            if (index != -1) {
                              final updatedEducation = List<Education>.from(_resume.education);
                              updatedEducation[index] = education;
                              _updateResume(_resume.copyWith(education: updatedEducation));
                            }
                          } else {
                            final updatedEducation = List<Education>.from(_resume.education)..add(education);
                            _updateResume(_resume.copyWith(education: updatedEducation));
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(existingEducation == null ? 'Add' : 'Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectForm() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _resume.projects.length + 1,
            itemBuilder: (context, index) {
              if (index == _resume.projects.length) {
                return ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _projectNameController.clear();
                      _projectDescriptionController.clear();
                      _projectTechnologiesController.clear();
                      _projectLinkController.clear();
                      _startDate = null;
                      _endDate = null;
                    });
                    _showProjectEditor();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Project'),
                );
              }

              final project = _resume.projects[index];
              return Card(
                child: ListTile(
                  title: Text(project.name),
                  subtitle: Text('${project.startDate?.month ?? ''}/${project.startDate?.year ?? ''} - ${project.endDate == null ? 'Present' : '${project.endDate!.month}/${project.endDate!.year}'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            _projectNameController.text = project.name;
                            _projectDescriptionController.text = project.description;
                            _projectTechnologiesController.text = project.technologies.join(', ');
                            _projectLinkController.text = project.link ?? '';
                            _startDate = project.startDate;
                            _endDate = project.endDate;
                          });
                          _showProjectEditor(existingProject: project);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            final updatedProjects = List<Project>.from(_resume.projects)..removeAt(index);
                            _updateResume(_resume.copyWith(projects: updatedProjects));
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showProjectEditor({Project? existingProject}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _projectFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existingProject == null ? 'Add Project' : 'Edit Project',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectNameController,
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectDescriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectTechnologiesController,
                  decoration: const InputDecoration(
                    labelText: 'Technologies (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _projectLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Project Link',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Start Date'),
                        subtitle: Text(_startDate == null ? 'Not set' : '${_startDate!.month}/${_startDate!.year}'),
                        onTap: () => _selectProjectDate(context, true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('End Date'),
                        subtitle: Text(_endDate == null ? 'Not set' : '${_endDate!.month}/${_endDate!.year}'),
                        onTap: () => _selectProjectDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_projectFormKey.currentState?.validate() ?? false) {
                          final project = Project(
                            id: existingProject?.id ?? DateTime.now().toString(),
                            name: _projectNameController.text,
                            description: _projectDescriptionController.text,
                            technologies: _projectTechnologiesController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                            link: _projectLinkController.text.isEmpty ? null : _projectLinkController.text,
                            startDate: _startDate!,
                            endDate: _endDate,
                          );

                          if (existingProject != null) {
                            final index = _resume.projects.indexWhere((p) => p.id == existingProject.id);
                            if (index != -1) {
                              final updatedProjects = List<Project>.from(_resume.projects);
                              updatedProjects[index] = project;
                              _updateResume(_resume.copyWith(projects: updatedProjects));
                            }
                          } else {
                            final updatedProjects = List<Project>.from(_resume.projects)..add(project);
                            _updateResume(_resume.copyWith(projects: updatedProjects));
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Text(existingProject == null ? 'Add' : 'Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skillController,
                  decoration: const InputDecoration(
                    labelText: 'Add Skill',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _addSkill,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _skills.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_skills[index].name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeSkill(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagesForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _languageNameController,
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _selectedLevel,
                items: LanguageLevel.values.map((level) {
                  return DropdownMenuItem<String>(
                    value: level.toString().split('.').last,
                    child: Text(level.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLevel = newValue;
                    });
                  }
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _addLanguage,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_languages[index].name),
                subtitle: Text(_languages[index].level.toString().split('.').last),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeLanguage(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCertificatesForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _certificateNameController,
                decoration: const InputDecoration(
                  labelText: 'Certificate Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issuingOrganizationController,
                decoration: const InputDecoration(
                  labelText: 'Issuing Organization',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _issueDateController,
                      decoration: const InputDecoration(
                        labelText: 'Issue Date (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _credentialIdController,
                decoration: const InputDecoration(
                  labelText: 'Credential ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addCertificate,
                child: const Text('Add Certificate'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _certificates.length,
            itemBuilder: (context, index) {
              final certificate = _certificates[index];
              return Card(
                child: ListTile(
                  title: Text(certificate.name),
                  subtitle: Text(
                      '${certificate.issuer}\n${certificate.issueDate.month}/${certificate.issueDate.year}${certificate.expiryDate != null ? ' - ${certificate.expiryDate!.month}/${certificate.expiryDate!.year}' : ''}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeCertificate(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit ${_getSectionTitle()}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildSectionEditor(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _saveChanges();
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSectionTitle() {
    switch (widget.section) {
      case 'personal_info':
        return 'Personal Information';
      case 'summary':
        return 'Professional Summary';
      case 'work_experience':
        return 'Work Experience';
      case 'education':
        return 'Education';
      case 'skills':
        return 'Skills';
      case 'projects':
        return 'Projects';
      case 'languages':
        return 'Languages';
      case 'certificates':
        return 'Certificates';
      default:
        return widget.section;
    }
  }

  Widget _buildSectionEditor() {
    switch (widget.section) {
      case 'personal_info':
        return _buildPersonalInfoForm();
      case 'summary':
        return _buildSummaryForm();
      case 'work_experience':
        return _buildWorkExperienceForm();
      case 'education':
        return _buildEducationForm();
      case 'skills':
        return _buildSkillsForm();
      case 'projects':
        return _buildProjectForm();
      case 'languages':
        return _buildLanguagesForm();
      case 'certificates':
        return _buildCertificatesForm();
      default:
        return const Center(child: Text('Section editor not implemented yet'));
    }
  }
}
