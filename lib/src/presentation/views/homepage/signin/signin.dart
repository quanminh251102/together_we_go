import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/router/app_router.dart';
import '../../../../utils/constants/colors.dart';
import '../../../cubits/app_socket.dart';
import '../../../cubits/calling_audio/calling_audio_cubit.dart';
import '../../../cubits/chat/chat_rooms_cubit.dart';
import '../../../cubits/chat/message_cubit.dart';
import '../../../cubits/forgot_password/forgot_password_cubit.dart';
import '../../../cubits/notification/notification_cubit.dart';
import '../../../cubits/signin/signin_cubit.dart';
import '../../../cubits/app_user.dart';
import 'widget/app_icon_button.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late FocusNode emailFocus;
  late FocusNode passwordFocus;
  late TextEditingController email;
  late TextEditingController password;
  late GlobalKey<FormState> _formKey;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    emailFocus.addListener(() {
      setState(() {});
    });
    passwordFocus.addListener(() {
      setState(() {});
    });
    _formKey = GlobalKey<FormState>();
    email = TextEditingController();
    password = TextEditingController();

    checkLastLogin();
  }

  void checkLastLogin() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    if (email != null && password != null) {
      BlocProvider.of<SigninCubit>(context).SignIn(email, password);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  clearTextData() {
    email.clear();
    password.clear();
  }

  ScaffoldFeatureController buildErrorLayout(e) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e),
        ),
      );
  @override
  Widget build(BuildContext context) {
    void init_app() async {
      appSocket.init(appUser.id);
      BlocProvider.of<MessageCubit>(context).init_socket_message = false;
      BlocProvider.of<CallingAudioCubit>(context).init_socket = false;

      BlocProvider.of<MessageCubit>(context).init_socket();
      BlocProvider.of<CallingAudioCubit>(context).init_socket_calling_audio();
      BlocProvider.of<ChatRoomsCubit>(context).init_socket_chat_room();
      BlocProvider.of<NotificationCubit>(context).init_socket_notifications();
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : BlocConsumer<SigninCubit, SigninState>(
                listener: (context, state) {
                  if (state is SigninError) {
                    buildErrorLayout(state.content);
                  } else if (state is SigninSuccess) {
                    clearTextData();
                    init_app();
                    appRouter
                        .push(HomePageViewRoute(email: state.email, index: 0));
                  }
                },
                builder: (context, state) {
                  if (state is SigninLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.08,
                              left: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.2),
                                child: const Text(
                                  'Đăng nhập vào tài khoản của bạn',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                        focusNode: emailFocus,
                                        controller: email,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng nhập email";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true, //<-- SEE HERE
                                          fillColor: emailFocus.hasFocus
                                              ? AppColors.primaryColor
                                                  .withOpacity(0.1)
                                              : Colors.grey.withOpacity(0.1),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                color: AppColors.primaryColor),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              width: 2.0,
                                            ),
                                          ),
                                          hintText: 'Email',
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: emailFocus.hasFocus
                                                ? AppColors.primaryColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: TextFormField(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        focusNode: passwordFocus,
                                        controller: password,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Vui lòng nhập mật khẩu";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                            focusColor: Colors.black,
                                            filled: true, //<-- SEE HERE
                                            fillColor: passwordFocus.hasFocus
                                                ? AppColors.primaryColor
                                                    .withOpacity(0.1)
                                                : Colors.grey.withOpacity(0.1),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                width: 2.0,
                                              ),
                                            ),
                                            hintText: 'Mật khẩu',
                                            prefixIcon: Icon(
                                                Icons.password_outlined,
                                                color: passwordFocus.hasFocus
                                                    ? AppColors.primaryColor
                                                    : Colors.black),
                                            suffixIcon: Icon(
                                              Icons.lock_outline,
                                              color: passwordFocus.hasFocus
                                                  ? AppColors.primaryColor
                                                  : Colors.black,
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          BlocProvider.of<SigninCubit>(context)
                                              .SignIn(
                                                  email.text, password.text);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.06,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: const Center(
                                          child: Text(
                                            'Đăng nhập',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<ForgotPasswordCubit>(
                                                context)
                                            .init();
                                        appRouter.push(
                                            const ForgotPasswordScreenRoute());
                                      },
                                      child: const Center(
                                        child: Text(
                                          'Quên mật khẩu? ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.primaryColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Row(
                                      children: const [
                                        Expanded(
                                            child: Divider(
                                          thickness: 0.2,
                                          color: Colors.black,
                                        )),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Text(
                                            "Hoặc đăng nhập bằng",
                                            style: TextStyle(
                                              color: Colors.black26,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Divider(
                                          thickness: 0.2,
                                          color: Colors.black,
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: () {
                                            BlocProvider.of<SigninCubit>(
                                                    context)
                                                .SignInWithGoogle();
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/google_box.svg',
                                            height: 45,
                                            width: 45,
                                          ),
                                        ),
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: () {
                                            BlocProvider.of<SigninCubit>(
                                                    context)
                                                .SignInWithFacebook();
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/facebook.svg',
                                            height: 50,
                                            width: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                    ),
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Bạn chưa có tài khoản? ',
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => appRouter.push(
                                                    const SignUpViewRoute()),
                                              text: 'Đăng ký tại đây',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
      ),
    );
  }
}
