import 'package:resume_builder_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> signup(String email, String password);
  Future<User> signInWithGoogle();
  Future<void> signOut();

  // Profile management
  Future<User> getUserProfile(String uid);
  Future<User> updateUserProfile({
    required String displayName,
    String? photoURL,
  });
  Future<User> updateEmail(String newEmail);
  Future<User> updatePassword(String newPassword);
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
}
