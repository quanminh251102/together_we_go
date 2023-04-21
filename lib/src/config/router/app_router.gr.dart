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
    ChatPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const ChatPage(),
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
    NewBookingViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const NewBookingView(),
      );
    },
    CallingAudioPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const CallingAudioPage(),
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
          ChatPageRoute.name,
          path: '/chat-page',
        ),
        RouteConfig(
          HomePageViewRoute.name,
          path: '/home-page-view',
        ),
        RouteConfig(
          SignUpViewRoute.name,
          path: '/sign-up-view',
        ),
        RouteConfig(
          NewBookingViewRoute.name,
          path: '/new-booking-view',
        ),
        RouteConfig(
          CallingAudioPageRoute.name,
          path: '/calling-audio-page',
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

/// generated route for
/// [NewBookingView]
class NewBookingViewRoute extends PageRouteInfo<void> {
  const NewBookingViewRoute()
      : super(
          NewBookingViewRoute.name,
          path: '/new-booking-view',
        );

  static const String name = 'NewBookingViewRoute';
}

/// generated route for
/// [CallingAudioPage]
class CallingAudioPageRoute extends PageRouteInfo<void> {
  const CallingAudioPageRoute()
      : super(
          CallingAudioPageRoute.name,
          path: '/calling-audio-page',
        );

  static const String name = 'CallingAudioPageRoute';
}
