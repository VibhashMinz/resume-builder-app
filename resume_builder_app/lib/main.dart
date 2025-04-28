import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/di/service_locator.dart';
import 'package:resume_builder_app/core/routes/routes.dart';
import 'package:resume_builder_app/core/theme/app_theme.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_bloc.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_state.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_bloc.dart';
import 'package:resume_builder_app/features/resume/presentation/blocs/resume_section_bloc.dart';

Future<void> setupLocator() async {
  await init();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); // Initialize dependencies
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),
        BlocProvider<ResumeBloc>(
          create: (context) => sl<ResumeBloc>(),
        ),
        BlocProvider<ResumeSectionBloc>(
          create: (context) => sl<ResumeSectionBloc>(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) => sl<ThemeBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Resume Builder',
            theme: state.themeData ?? AppTheme.lightTheme,
            onGenerateRoute: AppRoutes.generateRoute,
            initialRoute: AppRoutes.splash,
          );
        },
      ),
    );
  }
}
