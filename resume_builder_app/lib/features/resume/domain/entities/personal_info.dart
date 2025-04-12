import 'package:equatable/equatable.dart';

class PersonalInfo extends Equatable {
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

  const PersonalInfo({
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

  PersonalInfo copyWith({
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
    return PersonalInfo(
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

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        address,
        city,
        state,
        country,
        zipCode,
        linkedIn,
        github,
        website,
        summary,
      ];
}
