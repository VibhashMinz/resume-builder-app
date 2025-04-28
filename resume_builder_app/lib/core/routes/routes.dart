import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resume_builder_app/core/di/service_locator.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_bloc.dart';
import 'package:resume_builder_app/features/auth/presentation/pages/login_page.dart';
import 'package:resume_builder_app/features/auth/presentation/pages/signup_page.dart';
import 'package:resume_builder_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:resume_builder_app/features/home/presentation/pages/home_page.dart';
import 'package:resume_builder_app/features/resume/presentation/pages/create_resume_page.dart';
import 'package:resume_builder_app/features/resume/presentation/pages/edit_resume_page.dart';
import 'package:resume_builder_app/features/resume/presentation/pages/resume_list_page.dart';
import 'package:resume_builder_app/features/resume/presentation/pages/select_template_page.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/create_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/get_resumes.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/update_resume.dart';
import 'package:resume_builder_app/features/resume/domain/usecases/delete_resume.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String createResume = '/create-resume';
  static const String resumeList = '/resume_list';
  static const String editResume = '/edit_resume';
  static const String selectTemplate = '/select-template';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<ThemeBloc>(),
            child: const SplashPage(),
          ),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<ThemeBloc>(),
            child: const LoginPage(),
          ),
        );
      case signup:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<ThemeBloc>(),
            child: const SignupPage(),
          ),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: context.read<ThemeBloc>(),
            child: const HomePage(),
          ),
        );
      case createResume:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ThemeBloc>()),
              BlocProvider(
                create: (context) => ResumeBloc(
                  getResumes: sl<GetResumes>(),
                  getResume: sl<GetResume>(),
                  createResume: sl<CreateResume>(),
                  updateResume: sl<UpdateResume>(),
                  deleteResume: sl<DeleteResume>(),
                ),
              ),
            ],
            child: const CreateResumePage(),
          ),
        );
      case resumeList:
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ThemeBloc>()),
              BlocProvider(
                create: (context) => ResumeBloc(
                  getResumes: sl<GetResumes>(),
                  getResume: sl<GetResume>(),
                  createResume: sl<CreateResume>(),
                  updateResume: sl<UpdateResume>(),
                  deleteResume: sl<DeleteResume>(),
                )..add(GetResumesEvent(userId)),
              ),
            ],
            child: const ResumeListPage(),
          ),
        );
      case editResume:
        final resume = settings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ThemeBloc>()),
              BlocProvider(
                create: (context) => ResumeBloc(
                  getResumes: sl<GetResumes>(),
                  getResume: sl<GetResume>(),
                  createResume: sl<CreateResume>(),
                  updateResume: sl<UpdateResume>(),
                  deleteResume: sl<DeleteResume>(),
                ),
              ),
            ],
            child: EditResumePage(resume: resume),
          ),
        );
      case selectTemplate:
        final resume = settings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ThemeBloc>()),
              BlocProvider(
                create: (context) => ResumeBloc(
                  getResumes: sl<GetResumes>(),
                  getResume: sl<GetResume>(),
                  createResume: sl<CreateResume>(),
                  updateResume: sl<UpdateResume>(),
                  deleteResume: sl<DeleteResume>(),
                ),
              ),
            ],
            child: SelectTemplatePage(resume: resume),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
