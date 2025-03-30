import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resume_builder_app/core/theme/bloc/theme_bloc.dart';
import 'package:resume_builder_app/features/auth/presentation/pages/login_page.dart';
import 'package:resume_builder_app/features/auth/presentation/pages/signup_page.dart';
import 'package:resume_builder_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:resume_builder_app/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

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
