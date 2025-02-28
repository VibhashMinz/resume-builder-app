import 'package:resume_builder_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:resume_builder_app/features/auth/domain/entities/user.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    return User(id: userModel.id, email: userModel.email);
  }

  @override
  Future<User> signup(String email, String password) async {
    final userModel = await remoteDataSource.signup(email, password);
    return User(id: userModel.id, email: userModel.email);
  }
}
