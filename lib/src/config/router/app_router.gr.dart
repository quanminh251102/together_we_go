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
      final args = routeData.argsAs<HomePageViewRouteArgs>();
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: HomePageView(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SignUpViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const SignUpView(),
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
        RouteConfig(
          SignUpViewRoute.name,
          path: '/sign-up-view',
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
class HomePageViewRoute extends PageRouteInfo<HomePageViewRouteArgs> {
  HomePageViewRoute({
    Key? key,
    required String email,
  }) : super(
          HomePageViewRoute.name,
          path: '/home-page-view',
          args: HomePageViewRouteArgs(
            key: key,
            email: email,
          ),
        );

  static const String name = 'HomePageViewRoute';
}

class HomePageViewRouteArgs {
  const HomePageViewRouteArgs({
    this.key,
    required this.email,
  });

  final Key? key;

  final String email;

  @override
  String toString() {
    return 'HomePageViewRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [SignUpView]
class SignUpViewRoute extends PageRouteInfo<void> {
  const SignUpViewRoute()
      : super(
          SignUpViewRoute.name,
          path: '/sign-up-view',
        );

  static const String name = 'SignUpViewRoute';
}
