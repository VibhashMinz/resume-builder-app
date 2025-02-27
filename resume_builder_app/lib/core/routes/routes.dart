import 'package:flutter/material.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/pages/login_page.dart';
import 'package:resume_builder_app/fetaures/auth/presentation/pages/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Page not found'))));
    }
  }
}
