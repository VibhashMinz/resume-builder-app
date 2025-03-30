import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_bloc.dart';
import 'package:resume_builder_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:resume_builder_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:resume_builder_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/get_user_profile_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/update_email_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import 'package:resume_builder_app/features/auth/domain/usecases/send_email_verification_usecase.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register Firebase Services
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // Register Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl<AuthRemoteDataSource>()));

  // Register Use Cases
  sl.registerLazySingleton(() => Login(sl<AuthRepository>()));
  sl.registerLazySingleton(() => Signup(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetUserProfile(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdatePassword(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SendEmailVerification(sl<AuthRepository>()));

  // Register Blocs
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl<Login>(),
        signupUseCase: sl<Signup>(),
        googleSignInUseCase: sl<GoogleSignInUseCase>(),
        signOutUseCase: sl<SignOut>(),
      ));
  sl.registerLazySingleton(() => ThemeBloc(preferences: sl<SharedPreferences>()));
}
