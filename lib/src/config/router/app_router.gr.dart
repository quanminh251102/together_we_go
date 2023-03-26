// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    InitSocketRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const InitSocket(),
      );
    },
    SignInViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const SignInView(),
      );
    },
    ChatPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const ChatPage(),
      );
    },
    HomePageViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const HomePageView(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          InitSocketRoute.name,
          path: '/',
        ),
        RouteConfig(
          SignInViewRoute.name,
          path: '/sign-in-view',
        ),
        RouteConfig(
          ChatPageRoute.name,
          path: '/chat-page',
        ),
        RouteConfig(
          HomePageViewRoute.name,
          path: '/home-page-view',
        ),
      ];
}

/// generated route for
/// [InitSocket]
class InitSocketRoute extends PageRouteInfo<void> {
  const InitSocketRoute()
      : super(
          InitSocketRoute.name,
          path: '/',
        );

  static const String name = 'InitSocketRoute';
}

/// generated route for
/// [SignInView]
class SignInViewRoute extends PageRouteInfo<void> {
  const SignInViewRoute()
      : super(
          SignInViewRoute.name,
          path: '/sign-in-view',
        );

  static const String name = 'SignInViewRoute';
}

/// generated route for
/// [ChatPage]
class ChatPageRoute extends PageRouteInfo<void> {
  const ChatPageRoute()
      : super(
          ChatPageRoute.name,
          path: '/chat-page',
        );

  static const String name = 'ChatPageRoute';
}

/// generated route for
/// [HomePageView]
class HomePageViewRoute extends PageRouteInfo<void> {
  const HomePageViewRoute()
      : super(
          HomePageViewRoute.name,
          path: '/home-page-view',
        );

  static const String name = 'HomePageViewRoute';
}
