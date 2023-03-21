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
    SignInViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const SignInView(),
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
          SignInViewRoute.name,
          path: '/',
        ),
        RouteConfig(
          HomePageViewRoute.name,
          path: '/home-page-view',
        ),
      ];
}

/// generated route for
/// [SignInView]
class SignInViewRoute extends PageRouteInfo<void> {
  const SignInViewRoute()
      : super(
          SignInViewRoute.name,
          path: '/',
        );

  static const String name = 'SignInViewRoute';
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
