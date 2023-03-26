import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/views/init_socket.dart';
import '../../presentation/views/signin.dart';
import '../../presentation/views/homepage.dart';
import '../../presentation/views/chat_page.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: InitSocket, initial: true),
    AutoRoute(page: SignInView),
    AutoRoute(page: ChatPage),
    AutoRoute(page: HomePageView),
  ],
)
class AppRouter extends _$AppRouter {}

final appRouter = AppRouter();
