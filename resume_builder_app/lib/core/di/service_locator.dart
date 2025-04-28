import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_bloc.dart';
import 'package:resume_builder_app/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:resume_builder_app/features/auth/data/repositories/auth_repository_impl.dart';
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
import 'package:resume_builder_app/features/resume/data/repositories/resume_repository_impl.dart';
import 'package:resume_builder_app/features/resume/data/repositories/resume_section_repository.dart';
import 'package:resume_builder_app/features/resume/data/sources/resume_local_data_source.dart';
import 'package:resume_builder_app/features/resume/data/sources/resume_local_data_source_impl.dart';
import 'package:resume_builder_app/features/resume/data/sources/resume_remote_data_source.dart';
import 'package:resume_builder_app/features/resume/domain/repositories/resume_repository.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/create_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resumes.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/update_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/delete_resume.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_section_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register Firebase Services
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  // Register Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(),
  );
  sl.registerLazySingleton<ResumeLocalDataSource>(
    () => ResumeLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ResumeRemoteDataSource>(
    () => ResumeRemoteDataSource(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
      storage: sl<FirebaseStorage>(),
    ),
  );

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ResumeRepository>(
    () => ResumeRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
    ),
  );
  sl.registerLazySingleton<ResumeSectionRepository>(
    () => ResumeSectionRepository(),
  );

  // Register Use Cases
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => Signup(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateEmail(sl()));
  sl.registerLazySingleton(() => UpdatePassword(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => SendEmailVerification(sl()));

  // Register Resume Use Cases
  sl.registerLazySingleton(() => CreateResume(sl()));
  sl.registerLazySingleton(() => GetResume(sl()));
  sl.registerLazySingleton(() => GetResumes(sl()));
  sl.registerLazySingleton(() => UpdateResume(sl()));
  sl.registerLazySingleton(() => DeleteResume(sl()));

  // Register Blocs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      signupUseCase: sl(),
      googleSignInUseCase: sl(),
      signOutUseCase: sl(),
      updateUserProfileUseCase: sl(),
      updatePasswordUseCase: sl(),
      sendEmailVerificationUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ResumeBloc(
      createResume: sl(),
      getResume: sl(),
      getResumes: sl(),
      updateResume: sl(),
      deleteResume: sl(),
    ),
  );
  sl.registerFactory(
    () => ResumeSectionBloc(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton(() => ThemeBloc(preferences: sl<SharedPreferences>()));
}
