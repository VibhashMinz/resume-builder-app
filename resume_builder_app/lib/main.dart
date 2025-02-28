import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/di/service_locator.dart';
import 'package:resume_builder_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'core/routes/routes.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          create: (context) => sl<AuthBloc>(), // Using service locator
        ),
      ],
      child: MaterialApp(
        title: 'Resume Builder',
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
