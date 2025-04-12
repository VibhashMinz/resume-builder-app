import 'package:resume_builder_app/features/resume/domain/entities/personal_info.dart';

class PersonalInfoModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String linkedIn;
  final String github;
  final String website;
  final String summary;

  const PersonalInfoModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.linkedIn,
    required this.github,
    required this.website,
    required this.summary,
  });

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) {
    return PersonalInfoModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      zipCode: json['zipCode'] as String,
      linkedIn: json['linkedIn'] as String,
      github: json['github'] as String,
      website: json['website'] as String,
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'linkedIn': linkedIn,
      'github': github,
      'website': website,
      'summary': summary,
    };
  }

  factory PersonalInfoModel.fromEntity(PersonalInfo entity) {
    return PersonalInfoModel(
      id: entity.id,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      zipCode: entity.zipCode,
      linkedIn: entity.linkedIn,
      github: entity.github,
      website: entity.website,
      summary: entity.summary,
    );
  }

  PersonalInfo toEntity() {
    return PersonalInfo(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
      linkedIn: linkedIn,
      github: github,
      website: website,
      summary: summary,
    );
  }

  PersonalInfoModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    String? linkedIn,
    String? github,
    String? website,
    String? summary,
  }) {
    return PersonalInfoModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      website: website ?? this.website,
      summary: summary ?? this.summary,
    );
  }
}
