import 'package:cloud_firestore/cloud_firestore.dart';

class ResumeSectionModel {
  final String id;
  final String resumeId;
  final String userId;
  final String sectionType;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ResumeSectionModel({
    required this.id,
    required this.resumeId,
    required this.userId,
    required this.sectionType,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ResumeSectionModel.fromJson(Map<String, dynamic> json) {
    return ResumeSectionModel(
      id: json['id'] as String,
      resumeId: json['resumeId'] as String,
      userId: json['userId'] as String,
      sectionType: json['sectionType'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resumeId': resumeId,
      'userId': userId,
      'sectionType': sectionType,
      'data': data,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ResumeSectionModel copyWith({
    String? id,
    String? resumeId,
    String? userId,
    String? sectionType,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ResumeSectionModel(
      id: id ?? this.id,
      resumeId: resumeId ?? this.resumeId,
      userId: userId ?? this.userId,
      sectionType: sectionType ?? this.sectionType,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
