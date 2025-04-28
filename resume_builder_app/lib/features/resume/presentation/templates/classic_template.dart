import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/skill.dart';
import 'package:resume_builder_app/features/resume/domain/entities/language.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'base_template.dart';

class ClassicTemplate extends BaseTemplate {
  const ClassicTemplate({Key? key, required super.resume}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and contact info
          Container(
            padding: const EdgeInsets.only(bottom: 24.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${resume.personalInfo.firstName} ${resume.personalInfo.lastName}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (resume.personalInfo.email.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.email,
                        resume.personalInfo.email,
                      ),
                    if (resume.personalInfo.phone.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.phone,
                        resume.personalInfo.phone,
                      ),
                    if (resume.personalInfo.address.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.location_on,
                        resume.personalInfo.address,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Summary
          if (resume.summary.isNotEmpty) ...[
            _buildSectionTitle(context, 'PROFESSIONAL SUMMARY'),
            const SizedBox(height: 8),
            Text(
              resume.summary,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],
          // Work Experience
          if (resume.workExperience.isNotEmpty) ...[
            _buildSectionTitle(context, 'WORK EXPERIENCE'),
            const SizedBox(height: 8),
            ...resume.workExperience.map((exp) => _buildExperienceItem(context, exp)),
            const SizedBox(height: 24),
          ],
          // Education
          if (resume.education.isNotEmpty) ...[
            _buildSectionTitle(context, 'EDUCATION'),
            const SizedBox(height: 8),
            ...resume.education.map((edu) => _buildEducationItem(context, edu)),
            const SizedBox(height: 24),
          ],
          // Skills
          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle(context, 'SKILLS'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.skills
                  .map((skill) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          skill.name,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(BuildContext context, WorkExperience exp) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exp.position,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${formatDate(exp.startDate)} - ${formatDate(exp.endDate)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 179),
                ),
              ),
            ],
          ),
          Text(
            exp.company,
            style: theme.textTheme.bodyLarge,
          ),
          if (exp.responsibilities.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...exp.responsibilities.map((resp) => Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: theme.textTheme.bodyLarge,
                      ),
                      Expanded(
                        child: Text(
                          resp,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildEducationItem(BuildContext context, Education edu) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                edu.degree,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${formatDate(edu.startDate)} - ${formatDate(edu.endDate)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 179),
                ),
              ),
            ],
          ),
          Text(
            edu.institution,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
