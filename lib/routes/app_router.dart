import 'package:flutter/material.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/language_selection_screen.dart';
import '../screens/survey_screen.dart';
import '../screens/survey_completion_screen.dart';
import '../screens/survey_analytics_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String languageSelection = '/language-selection';
  static const String survey = '/survey';
  static const String surveyCompletion = '/survey-completion';
  static const String surveyAnalytics = '/survey-analytics';
  static const String login = '/login';
  static const String register = '/register';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _fade(const OnboardingScreen(), settings);
      case AppRoutes.home:
        return _slideFromBottom(const HomeScreen(), settings);
      case AppRoutes.languageSelection:
        return _slideFromRight(const LanguageSelectionScreen(), settings);
      case AppRoutes.survey:
        return _slideFromBottom(const SurveyScreen(), settings);
      case AppRoutes.surveyCompletion:
        return _fade(const SurveyCompletionScreen(), settings);
      case AppRoutes.surveyAnalytics:
        return _slideFromRight(const SurveyAnalyticsScreen(), settings);
      case AppRoutes.login:
        return _slideFromRight(const LoginScreen(), settings);
      case AppRoutes.register:
        return _slideFromRight(const RegisterScreen(), settings);
      default:
        // Unknown route → fallback to onboarding
        return _fade(const OnboardingScreen(), settings);
    }
  }

  static PageRoute _fade(Widget page, RouteSettings settings) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 250),
      );

  static PageRoute _slideFromRight(Widget page, RouteSettings settings) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );

  static PageRoute _slideFromBottom(Widget page, RouteSettings settings) => PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}
