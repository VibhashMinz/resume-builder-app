import 'package:resume_builder_app/core/network/api_client.dart';
import 'package:resume_builder_app/core/utils/constants.dart';
import 'package:resume_builder_app/fetaures/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;
  AuthRemoteDataSource(this.apiClient);

  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('${Constants.baseUrl}/login', data: {'email': email, 'password': password});
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> signup(String email, String password) async {
    final response = await apiClient.post('${Constants.baseUrl}/signup', data: {'email': email, 'password': password});
    return UserModel.fromJson(response.data);
  }
}
