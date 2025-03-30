import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_model.dart';
//import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/features/resume/data/models/work_experience_model.dart';
//import 'package:http/http.dart' as http;

enum ResumeTemplate { modern, classic, professional, creative, minimal, elegant }

class ResumeRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  ResumeRemoteDataSource()
      : _firestore = FirebaseFirestore.instance,
        _storage = FirebaseStorage.instance,
        _auth = FirebaseAuth.instance;

  // CRUD Operations
  Future<ResumeModel> createResume(ResumeModel resume) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final docRef = _firestore.collection('resumes').doc();
      final newResume = resume.copyWith(
        id: docRef.id,
        userId: user.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(newResume.toJson());
      return newResume;
    } catch (e) {
      throw Exception('Failed to create resume: ${e.toString()}');
    }
  }

  Future<ResumeModel> getResume(String id) async {
    try {
      final doc = await _firestore.collection('resumes').doc(id).get();
      if (!doc.exists) {
        throw Exception('Resume not found');
      }
      return ResumeModel.fromJson({'id': doc.id, ...doc.data()!});
    } catch (e) {
      throw Exception('Failed to get resume: ${e.toString()}');
    }
  }

  Future<List<ResumeModel>> getUserResumes(String userId) async {
    try {
      final querySnapshot = await _firestore.collection('resumes').where('userId', isEqualTo: userId).orderBy('updatedAt', descending: true).get();

      return querySnapshot.docs.map((doc) => ResumeModel.fromJson({'id': doc.id, ...doc.data()})).toList();
    } catch (e) {
      throw Exception('Failed to get user resumes: ${e.toString()}');
    }
  }

  Future<ResumeModel> updateResume(ResumeModel resume) async {
    try {
      final updatedResume = resume.copyWith(updatedAt: DateTime.now());
      await _firestore.collection('resumes').doc(resume.id).update(updatedResume.toJson());
      return updatedResume;
    } catch (e) {
      throw Exception('Failed to update resume: ${e.toString()}');
    }
  }

  Future<void> deleteResume(String id) async {
    try {
      await _firestore.collection('resumes').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete resume: ${e.toString()}');
    }
  }

  // Template Operations
  Future<List<ResumeTemplate>> getAvailableTemplates() async {
    // In a real app, this might come from Firestore or a template service
    return ResumeTemplate.values;
  }

  Future<String> generatePDF(String resumeId) async {
    try {
      final resume = await getResume(resumeId);
      // TODO: Implement PDF generation using a PDF service
      // This could use a Cloud Function or a separate PDF generation service
      throw UnimplementedError('PDF generation not implemented');
    } catch (e) {
      throw Exception('Failed to generate PDF: ${e.toString()}');
    }
  }

  Future<String> downloadResume(String resumeId, String format) async {
    try {
      switch (format.toLowerCase()) {
        case 'pdf':
          return await generatePDF(resumeId);
        case 'json':
          return await exportToJson(resumeId);
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      throw Exception('Failed to download resume: ${e.toString()}');
    }
  }

  // Sharing and Visibility
  Future<void> setResumeVisibility(String id, bool isPublic) async {
    try {
      await _firestore.collection('resumes').doc(id).update({'isPublic': isPublic});
    } catch (e) {
      throw Exception('Failed to update resume visibility: ${e.toString()}');
    }
  }

  Future<String> shareResume(String id) async {
    try {
      // Generate a sharing URL (could be implemented with Dynamic Links)
      // For now, return a simple URL
      return 'https://yourapp.com/resume/$id';
    } catch (e) {
      throw Exception('Failed to share resume: ${e.toString()}');
    }
  }

  Future<ResumeModel> duplicateResume(String id) async {
    try {
      final original = await getResume(id);
      final duplicate = ResumeModel.fromJson(original.toJson()).copyWith(
        id: '',
        title: '${original.title} (Copy)',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return await createResume(duplicate);
    } catch (e) {
      throw Exception('Failed to duplicate resume: ${e.toString()}');
    }
  }

  // Import/Export
  Future<ResumeModel> importFromLinkedIn(String linkedInUrl) async {
    try {
      // TODO: Implement LinkedIn scraping or API integration
      throw UnimplementedError('LinkedIn import not implemented');
    } catch (e) {
      throw Exception('Failed to import from LinkedIn: ${e.toString()}');
    }
  }

  Future<String> exportToJson(String id) async {
    try {
      final resume = await getResume(id);
      return jsonEncode(resume.toJson());
    } catch (e) {
      throw Exception('Failed to export resume: ${e.toString()}');
    }
  }

  Future<ResumeModel> importFromJson(String jsonString) async {
    try {
      final data = jsonDecode(jsonString);
      return ResumeModel.fromJson(data);
    } catch (e) {
      throw Exception('Failed to import resume: ${e.toString()}');
    }
  }

  // Analytics
  Future<Map<String, dynamic>> getResumeAnalytics(String id) async {
    try {
      final resume = await getResume(id);
      // Calculate various metrics
      return {
        'skillCount': resume.skills.length,
        'experienceYears': _calculateTotalExperience(resume.workExperience),
        'completionScore': _calculateCompletionScore(resume),
        'lastUpdated': resume.updatedAt,
      };
    } catch (e) {
      throw Exception('Failed to get resume analytics: ${e.toString()}');
    }
  }

  Future<List<String>> getSuggestedSkills(String category) async {
    try {
      // In a real app, this would come from a skills database or API
      // For now, return some example skills
      switch (category) {
        case 'technical':
          return [
            'JavaScript',
            'Python',
            'React',
            'Node.js',
            'Flutter',
            'Firebase',
          ];
        case 'soft':
          return [
            'Leadership',
            'Communication',
            'Problem Solving',
            'Team Work',
            'Time Management',
          ];
        default:
          return [];
      }
    } catch (e) {
      throw Exception('Failed to get suggested skills: ${e.toString()}');
    }
  }

  Future<List<String>> getSuggestedJobTitles() async {
    try {
      // In a real app, this would come from a job titles database or API
      return [
        'Software Engineer',
        'Full Stack Developer',
        'Mobile Developer',
        'Frontend Developer',
        'Backend Developer',
        'DevOps Engineer',
      ];
    } catch (e) {
      throw Exception('Failed to get suggested job titles: ${e.toString()}');
    }
  }

  // Helper Methods
  double _calculateTotalExperience(List<WorkExperienceModel> experiences) {
    double totalYears = 0;
    for (final exp in experiences) {
      final start = exp.startDate;
      final end = exp.endDate ?? DateTime.now();
      totalYears += end.difference(start).inDays / 365;
    }
    return double.parse(totalYears.toStringAsFixed(1));
  }

  double _calculateCompletionScore(ResumeModel resume) {
    int totalFields = 0;
    int completedFields = 0;

    // Personal Info
    final personalInfo = resume.personalInfo;
    totalFields += 8; // All possible fields in PersonalInfo
    completedFields += [
      personalInfo.fullName,
      personalInfo.email,
      personalInfo.phone,
      personalInfo.address,
      personalInfo.photoUrl,
      personalInfo.linkedInUrl,
      personalInfo.githubUrl,
      personalInfo.portfolioUrl,
    ].where((field) => field != null && field.isNotEmpty).length;

    // Education
    totalFields += resume.education.length * 5; // Fields per education entry
    for (final edu in resume.education) {
      completedFields += [
        edu.institution,
        edu.degree,
        edu.field,
        edu.startDate,
        edu.endDate,
      ].where((field) => field != null).length;
    }

    // Work Experience
    totalFields += resume.workExperience.length * 7; // Fields per work experience entry
    for (final exp in resume.workExperience) {
      completedFields += [
        exp.company,
        exp.position,
        exp.location,
        exp.startDate,
        exp.endDate,
        ...exp.responsibilities,
        ...exp.achievements,
      ].where((field) => field != null).length;
    }

    // Projects
    totalFields += resume.projects.length * 7; // Fields per project entry
    for (final proj in resume.projects) {
      completedFields += [
        proj.title,
        proj.description,
        proj.startDate,
        proj.endDate,
        proj.url,
        ...proj.technologies,
        ...proj.achievements,
      ].where((field) => field != null).length;
    }

    // Skills, Languages, Certificates
    totalFields += resume.skills.length + resume.languages.length + resume.certificates.length;
    completedFields += resume.skills.length + resume.languages.length + resume.certificates.length;

    // Summary
    totalFields += 1;
    if (resume.summary.isNotEmpty) completedFields += 1;

    return (completedFields / totalFields) * 100;
  }
}
