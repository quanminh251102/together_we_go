import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:together_we_go/src/presentation/cubits/calling_audio/calling_audio_cubit.dart';
import 'src/presentation/cubits/booking/cubit/booking_cubit.dart';
import 'src/presentation/cubits/chat/chat_rooms_cubit.dart';
import 'package:together_we_go/src/presentation/cubits/home_page/home_page_cubit.dart';
import 'src/presentation/cubits/forgot_password/forgot_password_cubit.dart';
import 'src/presentation/cubits/signin/signin_cubit.dart';
import 'src/config/router/app_router.dart';
import 'src/config/themes/app_themes.dart';
import 'src/presentation/cubits/signup/signup_cubit.dart';
import 'src/presentation/cubits/chat/message_cubit.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/presentation/cubits/update_profile/update_profile_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SigninCubit()),
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(create: (context) => MessageCubit()),
        BlocProvider(create: (context) => ChatRoomsCubit()),
        BlocProvider(create: (context) => HomePageCubit()),
        BlocProvider(create: (context) => BookingCubit()),
        BlocProvider(create: (context) => CallingAudioCubit()),
        BlocProvider(create: (context) => ForgotPasswordCubit()),
        BlocProvider(create: (context) => UpdateProfileCubit()),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
      ),
    );
  }
}
