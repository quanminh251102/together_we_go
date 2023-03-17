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
    HomePageViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const HomePageView(),
      );
    },
    SignInViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const SignInView(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          HomePageViewRoute.name,
          path: '/',
        ),
        RouteConfig(
          SignInViewRoute.name,
          path: '/sign-in-view',
        ),
      ];
}

/// generated route for
/// [HomePageView]
class HomePageViewRoute extends PageRouteInfo<void> {
  const HomePageViewRoute()
      : super(
          HomePageViewRoute.name,
          path: '/',
        );

  static const String name = 'HomePageViewRoute';
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
