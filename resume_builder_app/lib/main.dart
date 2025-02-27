import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/usecase/login_usecase.dart';
import 'package:resume_builder_app/core/usecase/signup_usecase.dart';
import 'package:resume_builder_app/fetaures/auth/data/repositories/auth_repository_impl.dart';
import 'package:resume_builder_app/fetaures/auth/data/sources/auth_remote_data_source.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/blocs/auth_bloc.dart';
import 'core/routes/routes.dart';
import 'core/theme/theme.dart';
import 'core/network/api_client.dart';
import 'package:dio/dio.dart';

void main() {
  final apiClient = ApiClient(dio: Dio());
  final remoteDataSource = AuthRemoteDataSource(apiClient);
  final authRepository = AuthRepositoryImpl(remoteDataSource);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        loginUseCase: Login(authRepository),
        signupUseCase: Signup(authRepository),
      ),
      child: MaterialApp(
        title: 'Resume Builder',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
