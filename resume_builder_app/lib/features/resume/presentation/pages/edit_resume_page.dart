import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/presentation/widgets/section_editor.dart';
import 'package:resume_builder_app/features/resume/presentation/widgets/template_selector.dart';

class EditResumePage extends StatefulWidget {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  const EditResumePage({super.key, required this.resume});

  @override
  State<EditResumePage> createState() => _EditResumePageState();
}

class _EditResumePageState extends State<EditResumePage> {
  late List<String> sectionOrder;
  late Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  @override
  void initState() {
    super.initState();
    resume = widget.resume;
    // Initialize section order based on current resume
    sectionOrder = [
      'personal_info',
      'summary',
      'work_experience',
      'education',
      'skills',
    ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Resume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<ResumeBloc>().add(UpdateResumeEvent(resume));
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(16),
        onReorder: _onReorder,
        children: [
          for (final section in sectionOrder)
            Card(
              key: ValueKey(section),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getSectionIcon(section),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getSectionTitle(section),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showSectionEditor(section);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildSectionPreview(section),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TemplateSelector(
              currentTemplate: resume.template,
              onTemplateSelected: (template) {
                setState(() {
                  resume = resume.copyWith(template: template);
                });
              },
            ),
          );
        },
        icon: const Icon(Icons.format_paint),
        label: const Text('Change Template'),
      ),
    );
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
}
