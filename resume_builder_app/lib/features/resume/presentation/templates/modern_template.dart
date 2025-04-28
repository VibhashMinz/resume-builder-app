import 'package:flutter/material.dart';
import 'package:resume_builder_app/features/resume/domain/entities/work_experience.dart';
import 'package:resume_builder_app/features/resume/domain/entities/education.dart';
import 'package:resume_builder_app/features/resume/domain/entities/project.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';
import 'base_template.dart';
import 'package:url_launcher/url_launcher.dart';

class ModernTemplate extends BaseTemplate {
  const ModernTemplate({super.key, required super.resume});

  @override
  String formatDate(DateTime? date) {
    if (date == null) return 'Present';
    return '${date.month}/${date.year}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = getResponsiveTextStyle(context);

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 26),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${resume.personalInfo.firstName} ${resume.personalInfo.lastName}',
                  style: textStyle.copyWith(
                    fontSize: textStyle.fontSize! * 1.5,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    if (resume.personalInfo.email.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.email,
                        resume.personalInfo.email,
                        onTap: () => _launchUrl('mailto:${resume.personalInfo.email}'),
                      ),
                    if (resume.personalInfo.phone.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.phone,
                        resume.personalInfo.phone,
                        onTap: () => _launchUrl('tel:${resume.personalInfo.phone}'),
                      ),
                    if (resume.personalInfo.address.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.location_on,
                        resume.personalInfo.address,
                      ),
                    if (resume.personalInfo.website.isNotEmpty)
                      _buildContactItem(
                        context,
                        Icons.language,
                        resume.personalInfo.website,
                        onTap: () => _launchUrl(resume.personalInfo.website),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Summary
          if (resume.summary.isNotEmpty) ...[
            _buildSectionTitle(context, 'Professional Summary'),
            const SizedBox(height: 8),
            Text(
              resume.summary,
              style: textStyle,
            ),
            const SizedBox(height: 24),
          ],
          // Work Experience
          if (resume.workExperience.isNotEmpty) ...[
            _buildSectionTitle(context, 'Work Experience'),
            const SizedBox(height: 8),
            ...resume.workExperience.map((exp) => _buildExperienceItem(context, exp)),
            const SizedBox(height: 24),
          ],
          // Education
          if (resume.education.isNotEmpty) ...[
            _buildSectionTitle(context, 'Education'),
            const SizedBox(height: 8),
            ...resume.education.map((edu) => _buildEducationItem(context, edu)),
            const SizedBox(height: 24),
          ],
          // Skills
          if (resume.skills.isNotEmpty) ...[
            _buildSectionTitle(context, 'Skills'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.skills
                  .map((skill) => Chip(
                        label: Text(
                          skill.name,
                          style: textStyle.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 26),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
          // Languages
          if (resume.languages.isNotEmpty) ...[
            _buildSectionTitle(context, 'Languages'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: resume.languages
                  .map((lang) => Chip(
                        label: Text(
                          '${lang.name} (${lang.level.toString().split('.').last})',
                          style: textStyle.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 26),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],
          // Certificates
          if (resume.certificates.isNotEmpty) ...[
            _buildSectionTitle(context, 'Certificates'),
            const SizedBox(height: 8),
            ...resume.certificates.map((cert) => _buildCertificateItem(context, cert)),
            const SizedBox(height: 24),
          ],
          // Projects
          if (resume.projects.isNotEmpty) ...[
            _buildSectionTitle(context, 'Projects'),
            const SizedBox(height: 8),
            ...resume.projects.map((proj) => _buildProjectItem(context, proj)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final textStyle = getResponsiveTextStyle(
      context,
      baseSize: 18,
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
    );
    return Text(title, style: textStyle);
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String text, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final textStyle = getResponsiveTextStyle(context);
    final widget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );

    return onTap != null
        ? InkWell(
            onTap: onTap,
            child: widget,
          )
        : widget;
  }

  Widget _buildExperienceItem(BuildContext context, WorkExperience exp) {
    final theme = Theme.of(context);
    final textStyle = getResponsiveTextStyle(context);
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
                style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${formatDate(exp.startDate)} - ${formatDate(exp.endDate)}',
                style: textStyle.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 179),
                ),
              ),
            ],
          ),
          Text(
            exp.company,
            style: textStyle.copyWith(
              color: theme.colorScheme.primary,
            ),
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
                        style: textStyle,
                      ),
                      Expanded(
                        child: Text(
                          resp,
                          style: textStyle,
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
    final textStyle = getResponsiveTextStyle(context);
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
                style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${formatDate(edu.startDate)} - ${formatDate(edu.endDate)}',
                style: textStyle.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 179),
                ),
              ),
            ],
          ),
          Text(
            edu.institution,
            style: textStyle.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateItem(BuildContext context, Certificate cert) {
    final theme = Theme.of(context);
    final textStyle = getResponsiveTextStyle(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cert.name,
                style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatDate(cert.issueDate),
                style: textStyle.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 179),
                ),
              ),
            ],
          ),
          Text(
            cert.issuer,
            style: textStyle.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(BuildContext context, Project proj) {
    final theme = Theme.of(context);
    final textStyle = getResponsiveTextStyle(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            proj.name,
            style: textStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (proj.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              proj.description,
              style: textStyle,
            ),
          ],
          if (proj.technologies.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: proj.technologies
                  .map((tech) => Chip(
                        label: Text(
                          tech,
                          style: textStyle.copyWith(
                            fontSize: textStyle.fontSize! * 0.9,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 26),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
