import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/presentation/widgets/section_editor.dart';

class CreateResumePage extends StatefulWidget {
  const CreateResumePage({super.key});

  @override
  State<CreateResumePage> createState() => _CreateResumePageState();
}

class _CreateResumePageState extends State<CreateResumePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late List<String> sectionOrder;
  late Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  @override
  void initState() {
    super.initState();
    // Initialize section order
    sectionOrder = [
      'personal_info',
      'summary',
      'work_experience',
      'education',
      'skills',
      'projects',
      'languages',
      'certificates',
    ];

    // Initialize empty resume with default template
    resume = Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate>(
      id: '',
      userId: '',
      title: '',
      template: ResumeTemplate.modern, // Default template
      personalInfo: const PersonalInfo(
        id: '',
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        address: '',
        city: '',
        state: '',
        country: '',
        zipCode: '',
        linkedIn: '',
        github: '',
        website: '',
        summary: '',
      ),
      education: <Education>[],
      workExperience: <WorkExperience>[],
      projects: <Project>[],
      skills: <Skill>[],
      languages: <Language>[],
      certificates: <Certificate>[],
      summary: '',
      isPublic: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final String item = sectionOrder.removeAt(oldIndex);
      sectionOrder.insert(newIndex, item);
    });
  }

  void _updateResume(Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> updatedResume) {
    setState(() {
      resume = updatedResume;
    });
  }

  void _createResume() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedResume = resume.copyWith(
        title: _titleController.text,
      );
      context.read<ResumeBloc>().add(CreateResumeEvent(updatedResume));
    }
  }

  IconData _getSectionIcon(String section) {
    switch (section) {
      case 'personal_info':
        return Icons.person;
      case 'summary':
        return Icons.description;
      case 'work_experience':
        return Icons.work;
      case 'education':
        return Icons.school;
      case 'skills':
        return Icons.star;
      case 'projects':
        return Icons.code;
      case 'languages':
        return Icons.language;
      case 'certificates':
        return Icons.card_membership;
      default:
        return Icons.info;
    }
  }

  String _getSectionTitle(String section) {
    switch (section) {
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
        return section;
    }
  }

  Widget _buildSectionPreview(String section) {
    switch (section) {
      case 'personal_info':
        return Text('${resume.personalInfo.firstName} ${resume.personalInfo.lastName}\n${resume.personalInfo.email}');
      case 'summary':
        return Text(resume.summary);
      case 'work_experience':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: resume.workExperience.map((exp) => Text('${exp.position} at ${exp.company}')).toList(),
        );
      case 'education':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: resume.education.map((edu) => Text('${edu.degree} from ${edu.institution}')).toList(),
        );
      case 'skills':
        return Wrap(
          spacing: 8,
          children: resume.skills.map((skill) => Chip(label: Text(skill.name))).toList(),
        );
      case 'projects':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: resume.projects.map((proj) => Text(proj.name)).toList(),
        );
      case 'languages':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: resume.languages.map((lang) => Text('${lang.name} - ${lang.level}')).toList(),
        );
      case 'certificates':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: resume.certificates.map((cert) => Text(cert.name)).toList(),
        );
      default:
        return const SizedBox();
    }
  }

  void _showSectionEditor(String section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SectionEditor(
        section: section,
        resume: resume,
        onUpdate: _updateResume,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResumeBloc, ResumeState>(
      listener: (context, state) {
        if (state is ResumeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ResumeLoaded) {
          // Navigate to template selection page
          Navigator.pushNamed(
            context,
            '/select-template',
            arguments: state.resume,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Resume'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Resume Title',
                    hintText: 'Enter a title for your resume',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ReorderableListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onReorder: _onReorder,
                  children: sectionOrder.map((section) {
                    return Card(
                      key: ValueKey(section),
                      child: ListTile(
                        leading: Icon(_getSectionIcon(section)),
                        title: Text(_getSectionTitle(section)),
                        subtitle: _buildSectionPreview(section),
                        trailing: const Icon(Icons.drag_handle),
                        onTap: () => _showSectionEditor(section),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _createResume,
          icon: const Icon(Icons.save),
          label: const Text('Save & Continue'),
        ),
      ),
    );
  }
}
