import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import '../../data/models/resume_model.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';

class ResumeExportService {
  Future<bool> _requestStoragePermission(BuildContext context) async {
    if (Platform.isIOS) {
      // For iOS, we need to request photos permission
      var status = await Permission.photos.status;
      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        final shouldOpenSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Photo Library Permission Required'),
            content: const Text(
              'Photo library permission is required to save your resume. Please enable it in the app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpenSettings == true) {
          await openAppSettings();
          return false;
        }
        return false;
      }

      status = await Permission.photos.request();
      if (status.isGranted) return true;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo library permission is required to save your resume.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } else {
      // Android permissions
      var status = await Permission.storage.status;
      if (status.isGranted) return true;

      // For Android 13+ (API level 33+), we need to request photos and videos permission
      status = await Permission.photos.request();
      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        final shouldOpenSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Storage Permission Required'),
            content: const Text(
              'Storage permission is required to save your resume. Please enable it in the app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpenSettings == true) {
          await openAppSettings();
          return false;
        }
        return false;
      }

      status = await Permission.storage.request();
      if (status.isGranted) return true;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to save your resume.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  Future<File> exportToPDF(Resume resume, ResumeTemplate template) async {
    final pdf = pw.Document();

    // Add content based on template
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 0,
              child: pw.Text(
                '${resume.personalInfo.firstName} ${resume.personalInfo.lastName}',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Contact Information',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Email: ${resume.personalInfo.email}'),
            pw.Text('Phone: ${resume.personalInfo.phone}'),
            pw.Text('Address: ${resume.personalInfo.address}'),
            if (resume.personalInfo.linkedIn.isNotEmpty) pw.Text('LinkedIn: ${resume.personalInfo.linkedIn}'),
            if (resume.personalInfo.github.isNotEmpty) pw.Text('GitHub: ${resume.personalInfo.github}'),
            if (resume.personalInfo.website.isNotEmpty) pw.Text('Website: ${resume.personalInfo.website}'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Summary',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(resume.personalInfo.summary),
            // Add other sections based on template
          ],
        ),
      ),
    );

    // Save the PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/resume_${resume.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  Future<String> exportToJSON(Resume resume) async {
    final Map<String, dynamic> json = {
      'id': resume.id,
      'userId': resume.userId,
      'title': resume.title,
      'template': resume.template.name,
      'personalInfo': {
        'id': resume.personalInfo.id,
        'firstName': resume.personalInfo.firstName,
        'lastName': resume.personalInfo.lastName,
        'email': resume.personalInfo.email,
        'phone': resume.personalInfo.phone,
        'address': resume.personalInfo.address,
        'city': resume.personalInfo.city,
        'state': resume.personalInfo.state,
        'country': resume.personalInfo.country,
        'zipCode': resume.personalInfo.zipCode,
        'linkedIn': resume.personalInfo.linkedIn,
        'github': resume.personalInfo.github,
        'website': resume.personalInfo.website,
        'summary': resume.personalInfo.summary,
      },
      'summary': resume.summary,
      'isPublic': resume.isPublic,
      'createdAt': resume.createdAt.toIso8601String(),
      'updatedAt': resume.updatedAt.toIso8601String(),
    };
    return jsonEncode(json);
  }

  Future<String> exportToMarkdown(Resume resume) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('# ${resume.personalInfo.firstName} ${resume.personalInfo.lastName}');
    buffer.writeln();

    // Contact Information
    buffer.writeln('## Contact Information');
    buffer.writeln('- Email: ${resume.personalInfo.email}');
    buffer.writeln('- Phone: ${resume.personalInfo.phone}');
    buffer.writeln('- Address: ${resume.personalInfo.address}');
    if (resume.personalInfo.linkedIn.isNotEmpty) buffer.writeln('- LinkedIn: ${resume.personalInfo.linkedIn}');
    if (resume.personalInfo.github.isNotEmpty) buffer.writeln('- GitHub: ${resume.personalInfo.github}');
    if (resume.personalInfo.website.isNotEmpty) buffer.writeln('- Website: ${resume.personalInfo.website}');
    buffer.writeln();

    // Summary
    buffer.writeln('## Summary');
    buffer.writeln(resume.personalInfo.summary);
    buffer.writeln();

    // Add other sections based on template

    return buffer.toString();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Present';
    return '${date.month}/${date.year}';
  }

  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      throw Exception('Failed to open file: $e');
    }
  }
}
