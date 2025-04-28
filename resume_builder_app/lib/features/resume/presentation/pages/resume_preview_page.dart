import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'package:resume_builder_app/features/resume/presentation/templates/modern_template.dart';
import 'package:resume_builder_app/features/resume/presentation/templates/classic_template.dart';
import 'package:resume_builder_app/features/resume/presentation/templates/professional_template.dart';
import 'package:resume_builder_app/features/resume/presentation/templates/creative_template.dart';
import 'package:resume_builder_app/features/resume/data/services/resume_export_service.dart';

class ResumePreviewPage extends StatelessWidget {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;
  final _exportService = ResumeExportService();

  ResumePreviewPage({
    super.key,
    required this.resume,
  });

  Future<void> _exportResume(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Export to PDF
      final filePath = await _exportService.exportToPDF(resume, resume.template);

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume exported successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Open the file
      await _exportService.openFile(filePath.path);
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error exporting resume: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resume.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportResume(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildTemplate(context),
        ),
      ),
    );
  }

  Widget _buildTemplate(BuildContext context) {
    switch (resume.template) {
      case ResumeTemplate.modern:
        return ModernTemplate(resume: resume);
      case ResumeTemplate.classic:
        return ClassicTemplate(resume: resume);
      case ResumeTemplate.professional:
        return ProfessionalTemplate(resume: resume);
      case ResumeTemplate.creative:
        return CreativeTemplate(resume: resume);
      case ResumeTemplate.minimal:
        return ModernTemplate(resume: resume); // Fallback to modern template
      case ResumeTemplate.elegant:
        return ClassicTemplate(resume: resume); // Fallback to classic template
    }
  }
}
