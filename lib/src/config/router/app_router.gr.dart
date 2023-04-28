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
    NewBookingViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const NewBookingView(),
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
    SignInViewRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const SignInView(),
      );
    },
    CallingAudioPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const CallingAudioPage(),
      );
    },
    ForgotPasswordScreenRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const ForgotPasswordScreen(),
      );
    },
    PrivacyPolicyPageRoute.name: (routeData) {
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: const PrivacyPolicyPage(),
      );
    },
    UpdateProfilePageRoute.name: (routeData) {
      final args = routeData.argsAs<UpdateProfilePageRouteArgs>();
      return AdaptivePage<dynamic>(
        routeData: routeData,
        child: UpdateProfilePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          NewBookingViewRoute.name,
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
          SignInViewRoute.name,
          path: '/sign-in-view',
        ),
        RouteConfig(
          CallingAudioPageRoute.name,
          path: '/calling-audio-page',
        ),
        RouteConfig(
          ForgotPasswordScreenRoute.name,
          path: '/forgot-password-screen',
        ),
        RouteConfig(
          PrivacyPolicyPageRoute.name,
          path: '/privacy-policy-page',
        ),
        RouteConfig(
          UpdateProfilePageRoute.name,
          path: '/update-profile-page',
        ),
      ];
}

/// generated route for
/// [NewBookingView]
class NewBookingViewRoute extends PageRouteInfo<void> {
  const NewBookingViewRoute()
      : super(
          NewBookingViewRoute.name,
          path: '/',
        );

  static const String name = 'NewBookingViewRoute';
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
/// [CallingAudioPage]
class CallingAudioPageRoute extends PageRouteInfo<void> {
  const CallingAudioPageRoute()
      : super(
          CallingAudioPageRoute.name,
          path: '/calling-audio-page',
        );

  static const String name = 'CallingAudioPageRoute';
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordScreenRoute extends PageRouteInfo<void> {
  const ForgotPasswordScreenRoute()
      : super(
          ForgotPasswordScreenRoute.name,
          path: '/forgot-password-screen',
        );

  static const String name = 'ForgotPasswordScreenRoute';
}

/// generated route for
/// [PrivacyPolicyPage]
class PrivacyPolicyPageRoute extends PageRouteInfo<void> {
  const PrivacyPolicyPageRoute()
      : super(
          PrivacyPolicyPageRoute.name,
          path: '/privacy-policy-page',
        );

  static const String name = 'PrivacyPolicyPageRoute';
}

/// generated route for
/// [UpdateProfilePage]
class UpdateProfilePageRoute extends PageRouteInfo<UpdateProfilePageRouteArgs> {
  UpdateProfilePageRoute({
    Key? key,
    required Map<String, dynamic> user,
  }) : super(
          UpdateProfilePageRoute.name,
          path: '/update-profile-page',
          args: UpdateProfilePageRouteArgs(
            key: key,
            user: user,
          ),
        );

  static const String name = 'UpdateProfilePageRoute';
}

class UpdateProfilePageRouteArgs {
  const UpdateProfilePageRouteArgs({
    this.key,
    required this.user,
  });

  final Key? key;

  final Map<String, dynamic> user;

  @override
  String toString() {
    return 'UpdateProfilePageRouteArgs{key: $key, user: $user}';
  }
}
