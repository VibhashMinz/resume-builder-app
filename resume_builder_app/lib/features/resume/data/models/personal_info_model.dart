import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';

class PersonalInfoModel extends PersonalInfo {
  const PersonalInfoModel({
    required super.fullName,
    required super.email,
    required super.phone,
    required super.address,
    super.photoUrl,
    super.linkedInUrl,
    super.githubUrl,
    super.portfolioUrl,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      photoUrl: json['photoUrl'] as String?,
      linkedInUrl: json['linkedInUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl,
      'linkedInUrl': linkedInUrl,
      'githubUrl': githubUrl,
      'portfolioUrl': portfolioUrl,
    };
  }

  PersonalInfoModel copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? photoUrl,
    String? linkedInUrl,
    String? githubUrl,
    String? portfolioUrl,
  }) {
    return PersonalInfoModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      linkedInUrl: linkedInUrl ?? this.linkedInUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
    );
  }
}
