import 'package:flutter/material.dart';

class PageTransitions {
  // Slide from right
  static PageRouteBuilder slideFromRight(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // Slide from bottom
  static PageRouteBuilder slideFromBottom(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
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
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  // Scale transition
  static PageRouteBuilder scaleTransition(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutBack;

        var scaleTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        );

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  // Rotation + Scale transition
  static PageRouteBuilder rotationScale(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var rotationTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.elasticOut),
        );

        var scaleTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOutBack),
        );

        return RotationTransition(
          turns: animation.drive(rotationTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    );
  }

  // Fade + Slide combination
  static PageRouteBuilder fadeSlide(Widget child, {Offset? begin}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideBegin = begin ?? const Offset(0.0, 0.3);
        const slideEnd = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideTween = Tween(begin: slideBegin, end: slideEnd).chain(
          CurveTween(curve: curve),
        );

        var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        );

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  // Modern slide with blur effect
  static PageRouteBuilder modernSlide(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 400),
    );
  }

  // Morphing transition
  static PageRouteBuilder morphTransition(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: Curves.easeInOutBack.transform(animation.value),
              child: Opacity(
                opacity: Curves.easeInOut.transform(animation.value),
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
    );
  }

  // Hero-style transition
  static PageRouteBuilder heroTransition(Widget child, String heroTag) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}

// Custom route for more control
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final RouteTransitionsBuilder transitionBuilder;

  CustomPageRoute({
    required this.child,
    this.curve = Curves.easeInOut,
    this.duration = const Duration(milliseconds: 500),
    required this.transitionBuilder,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: transitionBuilder,
          transitionDuration: duration,
          settings: settings,
        );
}

// Predefined transition types enum
enum TransitionType {
  slideRight,
  slideBottom,
  scale,
  rotationScale,
  fadeSlide,
  modernSlide,
  morph,
  hero,
}

// Helper class for easy usage
class NavigationHelper {
  static void navigateTo(
    BuildContext context,
    Widget destination, {
    TransitionType transition = TransitionType.slideRight,
    String? heroTag,
  }) {
    PageRouteBuilder route;

    switch (transition) {
      case TransitionType.slideRight:
        route = PageTransitions.slideFromRight(destination);
        break;
      case TransitionType.slideBottom:
        route = PageTransitions.slideFromBottom(destination);
        break;
      case TransitionType.scale:
        route = PageTransitions.scaleTransition(destination);
        break;
      case TransitionType.rotationScale:
        route = PageTransitions.rotationScale(destination);
        break;
      case TransitionType.fadeSlide:
        route = PageTransitions.fadeSlide(destination);
        break;
      case TransitionType.modernSlide:
        route = PageTransitions.modernSlide(destination);
        break;
      case TransitionType.morph:
        route = PageTransitions.morphTransition(destination);
        break;
      case TransitionType.hero:
        route = PageTransitions.heroTransition(destination, heroTag ?? 'hero');
        break;
    }

    Navigator.push(context, route);
  }

  static void navigateAndReplace(
    BuildContext context,
    Widget destination, {
    TransitionType transition = TransitionType.slideRight,
  }) {
    PageRouteBuilder route;

    switch (transition) {
      case TransitionType.slideRight:
        route = PageTransitions.slideFromRight(destination);
        break;
      case TransitionType.slideBottom:
        route = PageTransitions.slideFromBottom(destination);
        break;
      case TransitionType.scale:
        route = PageTransitions.scaleTransition(destination);
        break;
      case TransitionType.rotationScale:
        route = PageTransitions.rotationScale(destination);
        break;
      case TransitionType.fadeSlide:
        route = PageTransitions.fadeSlide(destination);
        break;
      case TransitionType.modernSlide:
        route = PageTransitions.modernSlide(destination);
        break;
      case TransitionType.morph:
        route = PageTransitions.morphTransition(destination);
        break;
      case TransitionType.hero:
        route = PageTransitions.heroTransition(destination, 'hero');
        break;
    }

    Navigator.pushReplacement(context, route);
  }
}