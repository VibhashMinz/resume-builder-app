import 'package:equatable/equatable.dart';

class Certificate extends Equatable {
  final String name;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialId;
  final String? url;

  const Certificate({
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.url,
  });

  @override
  List<Object?> get props => [
        name,
        issuer,
        issueDate,
        expiryDate,
        credentialId,
        url,
      ];
}
