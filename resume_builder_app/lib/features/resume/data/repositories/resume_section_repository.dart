import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/data/models/resume_section_model.dart';

class ResumeSectionRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'resume_sections';

  ResumeSectionRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ResumeSectionModel>> getSectionsByResumeId(String resumeId) async {
    final snapshot = await _firestore.collection(_collection).where('resumeId', isEqualTo: resumeId).get();

    return snapshot.docs.map((doc) => ResumeSectionModel.fromJson(doc.data())).toList();
  }

  Future<ResumeSectionModel> getSectionById(String sectionId) async {
    final doc = await _firestore.collection(_collection).doc(sectionId).get();
    return ResumeSectionModel.fromJson(doc.data()!);
  }

  Future<void> createSection(ResumeSectionModel section) async {
    await _firestore.collection(_collection).doc(section.id).set(section.toJson());
  }

  Future<void> updateSection(ResumeSectionModel section) async {
    await _firestore.collection(_collection).doc(section.id).update(section.toJson());
  }

  Future<void> deleteSection(String sectionId) async {
    await _firestore.collection(_collection).doc(sectionId).delete();
  }

  Future<void> deleteSectionsByResumeId(String resumeId) async {
    final snapshot = await _firestore.collection(_collection).where('resumeId', isEqualTo: resumeId).get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<ResumeSectionModel>> watchSectionsByResumeId(String resumeId) {
    return _firestore.collection(_collection).where('resumeId', isEqualTo: resumeId).snapshots().map((snapshot) => snapshot.docs.map((doc) => ResumeSectionModel.fromJson(doc.data())).toList());
  }
}
