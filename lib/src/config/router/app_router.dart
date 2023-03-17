import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:together_we_go/src/presentation/views/signin.dart';

import '../../presentation/views/homepage.dart';

part 'app_router.gr.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SignInView, initial: true),
    AutoRoute(page: HomePageView),
  ],
)
class AppRouter extends _$AppRouter {}

final appRouter = AppRouter();
