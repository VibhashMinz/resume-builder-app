import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_model.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume.dart';
import 'package:resume_builder_app/core/error/failures.dart';
import 'package:resume_builder_app/features/resume/domain/entities/resume_template.dart';
import 'package:resume_builder_app/features/resume/data/models/work_experience_model.dart';
//import 'package:http/http.dart' as http;

class ResumeRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final FirebaseStorage storage;

  ResumeRemoteDataSource({
    required this.firestore,
    required this.auth,
    required this.storage,
  });

  // CRUD Operations
  Future<Resume> createResume(ResumeModel resume) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Verify user is still authenticated and email is verified
      await user.reload();
      if (!user.emailVerified) {
        throw Exception('Please verify your email before creating a resume');
      }

      final docRef = firestore.collection('resumes').doc();
      final model = resume.copyWith(
        id: docRef.id,
        userId: user.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(model.toJson());
      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to create resume: ${e.toString()}');
    }
  }

  Future<Resume> getResume(String id) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final doc = await firestore.collection('resumes').doc(id).get();
      if (!doc.exists) {
        throw Exception('Resume not found');
      }

      final model = ResumeModel.fromJson({'id': doc.id, ...doc.data()!});
      if (model.userId != user.uid) {
        throw Exception('Unauthorized access to resume');
      }

      return model.toEntity();
    } catch (e) {
      throw Exception('Failed to get resume: ${e.toString()}');
    }
  }

  Future<List<Resume>> getUserResumes(String userId) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      if (userId != user.uid) {
        throw Exception('Unauthorized access to resumes');
      }

      final querySnapshot = await firestore.collection('resumes').where('userId', isEqualTo: userId).orderBy('updatedAt', descending: true).get();

      return querySnapshot.docs.map((doc) => ResumeModel.fromJson({'id': doc.id, ...doc.data()}).toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get user resumes: ${e.toString()}');
    }
  }

  Future<Resume> updateResume(ResumeModel resume) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw const UnauthenticatedFailure();
      }

      // Verify the resume exists and belongs to the user
      final doc = await firestore.collection('resumes').doc(resume.id).get();
      if (!doc.exists) {
        throw const NotFoundFailure();
      }

      final data = doc.data()!;
      if (data['userId'] != user.uid) {
        throw const UnauthorizedFailure();
      }

      // Create updated resume with current timestamp
      final model = resume.copyWith(
        updatedAt: DateTime.now(),
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );

      // Update the resume in Firestore
      await firestore.collection('resumes').doc(resume.id).update(model.toJson());

      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<void> deleteResume(String id) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final doc = await firestore.collection('resumes').doc(id).get();
      if (!doc.exists) {
        throw Exception('Resume not found');
      }

      final model = ResumeModel.fromJson({'id': doc.id, ...doc.data()!});
      if (model.userId != user.uid) {
        throw Exception('Unauthorized access to resume');
      }

      await firestore.collection('resumes').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete resume: ${e.toString()}');
    }
  }

  // Template Operations
  Future<List<ResumeTemplate>> getAvailableTemplates() async {
    try {
      final snapshot = await firestore.collection('templates').get();
      return snapshot.docs.map((doc) => ResumeTemplate.values[doc.data()['index'] as int]).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<String> generatePDF(String resumeId) async {
    try {
      // Implementation for PDF generation
      throw UnimplementedError('PDF generation not implemented');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<String> downloadResume(String resumeId, String format) async {
    try {
      // Implementation for resume download
      throw UnimplementedError('Resume download not implemented');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // Sharing and Visibility
  Future<void> setResumeVisibility(String id, bool isPublic) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const UnauthenticatedFailure();

      await firestore.collection('resumes').doc(id).update({'isPublic': isPublic});
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<String> shareResume(String id) async {
    try {
      final doc = await firestore.collection('resumes').doc(id).get();
      if (!doc.exists) throw const NotFoundFailure();

      final data = doc.data()!;
      final user = auth.currentUser;
      if (user == null) throw const UnauthenticatedFailure();
      if (data['userId'] != user.uid) throw const UnauthorizedFailure();

      // Create a shareable link
      final shareableDoc = await firestore.collection('shared_resumes').add({
        'resumeId': id,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': FieldValue.serverTimestamp(),
        'isPublic': data['isPublic'],
      });

      return 'https://your-app-domain.com/resume/${shareableDoc.id}';
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<Resume> duplicateResume(String id) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const UnauthenticatedFailure();

      final doc = await firestore.collection('resumes').doc(id).get();
      if (!doc.exists) throw const NotFoundFailure();

      final data = doc.data()!;
      if (data['userId'] != user.uid) throw const UnauthorizedFailure();

      final model = ResumeModel.fromJson({
        ...data,
        'id': '',
        'userId': user.uid,
        'title': '${data['title']} (Copy)',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      final docRef = await firestore.collection('resumes').add(model.toJson());
      return model.copyWith(id: docRef.id).toEntity();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  // Import/Export
  Future<Resume> importFromLinkedIn(String linkedInUrl) async {
    try {
      // Implementation for LinkedIn import
      throw UnimplementedError('LinkedIn import not implemented');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<String> exportToJson(String id) async {
    try {
      final doc = await firestore.collection('resumes').doc(id).get();
      if (!doc.exists) throw const NotFoundFailure();
      return doc.data().toString();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<ResumeModel> importFromJson(String jsonString) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw const UnauthenticatedFailure();

      final data = Map<String, dynamic>.from(json.decode(jsonString));
      final resume = ResumeModel.fromJson({
        ...data,
        'id': '',
        'userId': user.uid,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });

      final docRef = await firestore.collection('resumes').add(resume.toJson());
      return resume.copyWith(id: docRef.id);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  // Analytics
  Future<Map<String, dynamic>> getResumeAnalytics(String id) async {
    try {
      final doc = await firestore.collection('resumes').doc(id).get();
      if (!doc.exists) throw const NotFoundFailure();

      final data = doc.data()!;
      final user = auth.currentUser;
      if (user == null) throw const UnauthenticatedFailure();
      if (data['userId'] != user.uid) throw const UnauthorizedFailure();

      // Get view count
      final viewsSnapshot = await firestore.collection('resume_views').where('resumeId', isEqualTo: id).count().get();

      // Get download count
      final downloadsSnapshot = await firestore.collection('resume_downloads').where('resumeId', isEqualTo: id).count().get();

      return {
        'views': viewsSnapshot.count,
        'downloads': downloadsSnapshot.count,
        'lastUpdated': data['updatedAt'],
        'completionScore': _calculateCompletionScore(ResumeModel.fromJson({...data, 'id': id})),
      };
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<List<String>> getSuggestedSkills(String category) async {
    try {
      final snapshot = await firestore.collection('skills').where('category', isEqualTo: category).get();
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<List<String>> getSuggestedJobTitles() async {
    try {
      final snapshot = await firestore.collection('job_titles').get();
      return snapshot.docs.map((doc) => doc.data()['title'] as String).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // Helper Methods
  double _calculateCompletionScore(ResumeModel resume) {
    int totalFields = 0;
    int completedFields = 0;

    // Personal Info
    final personalInfo = resume.personalInfo;
    totalFields += 8; // All possible fields in PersonalInfo
    completedFields += [
      personalInfo.firstName,
      personalInfo.lastName,
      personalInfo.email,
      personalInfo.phone,
      personalInfo.address,
      personalInfo.linkedIn,
      personalInfo.github,
      personalInfo.website,
    ].where((field) => field.isNotEmpty).length;

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
        proj.name,
        proj.description,
        proj.startDate,
        proj.endDate,
        proj.link,
        ...proj.technologies,
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

  Future<List<ResumeModel>> getResumes() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw const UnauthenticatedFailure();
      }

      final querySnapshot = await firestore.collection('resumes').where('userId', isEqualTo: user.uid).orderBy('updatedAt', descending: true).get();

      return querySnapshot.docs.map((doc) => ResumeModel.fromJson({'id': doc.id, ...doc.data()})).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  Future<ResumeModel> getResumeById(String resumeId) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw const UnauthenticatedFailure();
      }

      final doc = await firestore.collection('resumes').doc(resumeId).get();
      if (!doc.exists) {
        throw const NotFoundFailure();
      }

      final data = doc.data()!;
      if (data['userId'] != user.uid) {
        throw const UnauthorizedFailure();
      }

      return ResumeModel.fromJson({'id': doc.id, ...data});
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }
}
