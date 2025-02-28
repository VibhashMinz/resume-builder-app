import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:resume_builder_app/core/usecase/login_usecase.dart';
import 'package:resume_builder_app/core/usecase/signup_usecase.dart';
import 'package:resume_builder_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:resume_builder_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_bloc.dart';

import '../network/api_client.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Register ApiClient (with Dio)
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dio: sl<Dio>()));

  // Register Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource(sl<ApiClient>()));

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));

  // Register Use Cases
  sl.registerLazySingleton(() => Login(sl<AuthRepository>()));
  sl.registerLazySingleton(() => Signup(sl<AuthRepository>()));

  // Register Bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl<Login>(),
        signupUseCase: sl<Signup>(),
      ));
}
