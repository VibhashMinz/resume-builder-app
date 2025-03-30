import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final String provider;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.createdAt,
    this.lastLoginAt,
    this.provider = 'email',
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoURL,
        createdAt,
        lastLoginAt,
        provider,
        isEmailVerified,
      ];
}
