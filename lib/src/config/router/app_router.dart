import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/views/booking/add_booking.dart';
import '../../presentation/views/calling_audio/calling_audio_page.dart';
import '../../presentation/views/forgot_pasword/forgot_password.dart';
import '../../presentation/views/profile_and_settings/privacy_policy/privacy_policy_page.dart';
import '../../presentation/views/profile_and_settings/update_profile/update_profile_page.dart';
import '../../presentation/views/homepage/signin/signin.dart';
import '../../presentation/views/homepage/homepage.dart';
import '../../presentation/views/chat/chat_page.dart';
import '../../presentation/views/homepage/signup/signup.dart';
import '../../presentation/views/tracking/tracking_route_screen.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SignInView, initial: true),
    AutoRoute(page: ChatPage),
    AutoRoute(page: HomePageView),
    AutoRoute(page: SignUpView),
    AutoRoute(page: NewBookingView),
    AutoRoute(page: CallingAudioPage),
    AutoRoute(page: ForgotPasswordScreen),
    AutoRoute(page: PrivacyPolicyPage),
    AutoRoute(page: UpdateProfilePage),
    AutoRoute(page: TrackingScreen),
  ],
)
class AppRouter extends _$AppRouter {}

final appRouter = AppRouter();
