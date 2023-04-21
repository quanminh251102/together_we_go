import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/views/booking/add_booking.dart';
import '../../presentation/views/calling_audio/calling_audio_page.dart';
import '../../presentation/views/signin.dart';
import '../../presentation/views/homepage/homepage.dart';
import '../../presentation/views/chat/chat_page.dart';
import '../../presentation/views/signup.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SignInView, initial: true),
    AutoRoute(page: ChatPage),
    AutoRoute(page: HomePageView),
    AutoRoute(page: SignUpView),
    AutoRoute(page: NewBookingView),
    AutoRoute(page: CallingAudioPage),
  ],
)
class AppRouter extends _$AppRouter {}

final appRouter = AppRouter();
