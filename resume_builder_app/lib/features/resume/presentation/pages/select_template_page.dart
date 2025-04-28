import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/presentation/widgets/template_selector.dart';
import 'package:resume_builder_app/core/routes/routes.dart';

class SelectTemplatePage extends StatefulWidget {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  const SelectTemplatePage({
    super.key,
    required this.resume,
  });

  @override
  State<SelectTemplatePage> createState() => _SelectTemplatePageState();
}

class _SelectTemplatePageState extends State<SelectTemplatePage> {
  late Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    resume = widget.resume;
  }

  void _updateTemplate(Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> updatedResume) {
    if (_isUpdating) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Ensure resume has correct ID and user ID
    final resumeToUpdate = updatedResume.copyWith(
      id: resume.id.isEmpty ? null : resume.id,
      userId: resume.userId.isEmpty ? user.uid : resume.userId,
    );

    setState(() {
      resume = resumeToUpdate;
      _isUpdating = true;
    });

    context.read<ResumeBloc>().add(UpdateResumeEvent(resumeToUpdate));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResumeBloc, ResumeState>(
      listener: (context, state) {
        if (state is ResumeError) {
          setState(() {
            _isUpdating = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is ResumeLoaded) {
          setState(() {
            _isUpdating = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Template updated successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to resume list
          Navigator.pushReplacementNamed(context, AppRoutes.resumeList);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Select Template'),
            actions: [
              if (_isUpdating)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Choose a template for your resume',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: TemplateSelector(
                  currentTemplate: resume.template,
                  onTemplateSelected: (template) {
                    _updateTemplate(resume.copyWith(template: template));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
