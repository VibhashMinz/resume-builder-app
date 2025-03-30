import 'package:equatable/equatable.dart';

class PersonalInfo extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String? photoUrl;
  final String? linkedInUrl;
  final String? githubUrl;
  final String? portfolioUrl;

  const PersonalInfo({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    this.photoUrl,
    this.linkedInUrl,
    this.githubUrl,
    this.portfolioUrl,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        address,
        photoUrl,
        linkedInUrl,
        githubUrl,
        portfolioUrl,
      ];
}
