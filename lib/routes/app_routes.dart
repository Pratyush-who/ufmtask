import 'package:flutter/material.dart';
import 'package:ufmtask/auth/otp_screen.dart';
import 'package:ufmtask/auth/screen/login_screen.dart';
import 'package:ufmtask/screen/dashboard/dashboard_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _slideRoute(const LoginScreen(), settings);
      case otp:
        final args = settings.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] as String?;
        return _slideRoute(OTPScreen(phone: phone ?? ''), settings);
      case dashboard:
        return _slideRoute(const DashboardScreen(), settings);
      default:
        return _slideRoute(const LoginScreen(), settings);
    }
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}