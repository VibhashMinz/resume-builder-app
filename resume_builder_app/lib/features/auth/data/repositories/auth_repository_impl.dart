import 'package:resume_builder_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    return userModel;
  }

  @override
  Future<User> signup(String email, String password) async {
    final userModel = await remoteDataSource.signup(email, password);
    return userModel;
  }

  @override
  Future<User> signInWithGoogle() async {
    final userModel = await remoteDataSource.signInWithGoogle();
    return userModel;
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<User> getUserProfile(String uid) async {
    final userModel = await remoteDataSource.getUserProfile(uid);
    return userModel;
  }

  @override
  Future<User> updateUserProfile({
    required String displayName,
    String? photoURL,
  }) async {
    final userModel = await remoteDataSource.updateUserProfile(
      displayName: displayName,
      photoURL: photoURL,
    );
    return userModel;
  }

  @override
  Future<User> updateEmail(String newEmail) async {
    final userModel = await remoteDataSource.updateEmail(newEmail);
    return userModel;
  }

  @override
  Future<User> updatePassword(String newPassword) async {
    final userModel = await remoteDataSource.updatePassword(newPassword);
    return userModel;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendEmailVerification() async {
    await remoteDataSource.sendEmailVerification();
  }
}
