import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';

class CertificateModel {
  final String name;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialId;
  final String? url;

  const CertificateModel({
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.url,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate'] as String) : null,
      credentialId: json['credentialId'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'credentialId': credentialId,
      'url': url,
    };
  }

  factory CertificateModel.fromEntity(Certificate entity) {
    return CertificateModel(
      name: entity.name,
      issuer: entity.issuer,
      issueDate: entity.issueDate,
      expiryDate: entity.expiryDate,
      credentialId: entity.credentialId,
      url: entity.url,
    );
  }

  Certificate toEntity() {
    return Certificate(
      name: name,
      issuer: issuer,
      issueDate: issueDate,
      expiryDate: expiryDate,
      credentialId: credentialId,
      url: url,
    );
  }

  CertificateModel copyWith({
    String? name,
    String? issuer,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? credentialId,
    String? url,
  }) {
    return CertificateModel(
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
      url: url ?? this.url,
    );
  }
}
