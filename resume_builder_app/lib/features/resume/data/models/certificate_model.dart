import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resume_builder_app/features/resume/domain/entities/certificate.dart';

class CertificateModel extends Certificate {
  const CertificateModel({
    required super.name,
    required super.issuer,
    required super.issueDate,
    super.expiryDate,
    super.credentialId,
    super.url,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      issueDate: (json['issueDate'] as Timestamp).toDate(),
      expiryDate: json['expiryDate'] != null ? (json['expiryDate'] as Timestamp).toDate() : null,
      credentialId: json['credentialId'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'issuer': issuer,
      'issueDate': Timestamp.fromDate(issueDate),
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'credentialId': credentialId,
      'url': url,
    };
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
