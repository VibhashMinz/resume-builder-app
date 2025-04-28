import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';

abstract class BaseTemplate extends StatelessWidget {
  final Resume<PersonalInfo, Education, WorkExperience, Project, Skill, Language, Certificate> resume;

  const BaseTemplate({Key? key, required this.resume}) : super(key: key);

  String formatDate(DateTime? date) {
    if (date == null) return 'Present';
    return '${date.month}/${date.year}';
  }

  // Helper method to get responsive text style
  TextStyle getResponsiveTextStyle(
    BuildContext context, {
    double baseSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    final constraints = MediaQuery.of(context).size;
    final scaleFactor = constraints.width / 360; // Base width for scaling
    final scaledSize = baseSize * scaleFactor.clamp(0.8, 1.2); // Limit scaling between 0.8x and 1.2x

    return TextStyle(
      fontSize: scaledSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  Widget buildPersonalInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${resume.personalInfo.firstName} ${resume.personalInfo.lastName}',
              style: getResponsiveTextStyle(
                context,
                baseSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (resume.personalInfo.email.isNotEmpty)
              Text(
                resume.personalInfo.email,
                style: getResponsiveTextStyle(context, baseSize: 14),
              ),
            if (resume.personalInfo.phone.isNotEmpty)
              Text(
                resume.personalInfo.phone,
                style: getResponsiveTextStyle(context, baseSize: 14),
              ),
            if (resume.personalInfo.address.isNotEmpty)
              Text(
                resume.personalInfo.address,
                style: getResponsiveTextStyle(context, baseSize: 14),
              ),
          ],
        );
      },
    );
  }

  Widget buildSummary() {
    if (resume.summary.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Professional Summary',
              style: getResponsiveTextStyle(
                context,
                baseSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              resume.summary,
              style: getResponsiveTextStyle(context, baseSize: 14),
            ),
          ],
        );
      },
    );
  }

  Widget buildWorkExperience() {
    if (resume.workExperience.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Work Experience',
              style: getResponsiveTextStyle(
                context,
                baseSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...resume.workExperience.map((exp) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exp.position,
                      style: getResponsiveTextStyle(
                        context,
                        baseSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${exp.company} | ${formatDate(exp.startDate)} - ${formatDate(exp.endDate)}',
                      style: getResponsiveTextStyle(context, baseSize: 14),
                    ),
                    if (exp.responsibilities.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      ...exp.responsibilities.map((resp) => Padding(
                            padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                            child: Text(
                              '• $resp',
                              style: getResponsiveTextStyle(context, baseSize: 14),
                            ),
                          )),
                    ],
                    const SizedBox(height: 8),
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget buildEducation() {
    if (resume.education.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Education',
              style: getResponsiveTextStyle(
                context,
                baseSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...resume.education.map((edu) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edu.degree,
                      style: getResponsiveTextStyle(
                        context,
                        baseSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${edu.institution} | ${formatDate(edu.startDate)} - ${formatDate(edu.endDate)}',
                      style: getResponsiveTextStyle(context, baseSize: 14),
                    ),
                    const SizedBox(height: 8),
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget buildSkills() {
    if (resume.skills.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skills',
              style: getResponsiveTextStyle(
                context,
                baseSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.skills
                  .map((skill) => Chip(
                        label: Text(
                          skill.name,
                          style: getResponsiveTextStyle(context, baseSize: 12),
                        ),
                      ))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPersonalInfo(),
              const SizedBox(height: 16),
              buildSummary(),
              const SizedBox(height: 16),
              buildWorkExperience(),
              const SizedBox(height: 16),
              buildEducation(),
              const SizedBox(height: 16),
              buildSkills(),
            ],
          ),
        );
      },
    );
  }
}
