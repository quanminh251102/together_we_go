import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../config/router/app_router.dart';
import '../../../../utils/constants/colors.dart';
import '../../../cubits/signup/signup_cubit.dart';
import '../signin/widget/app_icon_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  late FocusNode emailFocus;
  late FocusNode passwordConFirmFocus;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController email;
  late TextEditingController passwordConfirm;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    super.initState();
    usernameFocus = FocusNode();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    passwordConFirmFocus = FocusNode();
    usernameFocus.addListener(() {
      setState(() {});
    });
    emailFocus.addListener(() {
      setState(() {});
    });
    passwordConFirmFocus.addListener(() {
      setState(() {});
    });
    passwordFocus.addListener(() {
      setState(() {});
    });
    passwordConFirmFocus.addListener(() {
      setState(() {});
    });
    _formKey = GlobalKey<FormState>();
    username = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    passwordConfirm = TextEditingController();
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  clearTextData() {
    username.clear();
    email.clear();
    password.clear();
    passwordConfirm.clear();
  }

  ScaffoldFeatureController buildErrorLayout() =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.grey,
          content: const Text('Mật khẩu không khớp!'),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => appRouter.pop(),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimaryColor,
          ),
        ),
      ),
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupError) {
            buildErrorLayout();
          } else if (state is SignupSuccess) {
            clearTextData();
            appRouter.push(HomePageViewRoute(email: state.email, index: 0));
          }
        },
        builder: (context, state) {
          if (state is SignupLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return buildInitial(
                context,
                username,
                email,
                password,
                passwordConfirm,
                _formKey,
                usernameFocus,
                emailFocus,
                passwordFocus,
                passwordConFirmFocus);
          }
        },
      ),
    );
  }
}

Widget buildInitial(
        BuildContext context,
        TextEditingController username,
        TextEditingController email,
        TextEditingController password,
        TextEditingController passwordConfirm,
        GlobalKey<FormState> _formKey,
        FocusNode usernameFocus,
        FocusNode emailFocus,
        FocusNode passwordFocus,
        FocusNode passwordConfirmFocus) =>
    SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05),
        child: Container(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.2),
              child: const Text(
                'Tạo tài khoản mới của bạn',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      focusNode: usernameFocus,
                      controller: username,
                      decoration: InputDecoration(
                        filled: true, //<-- SEE HERE
                        fillColor: usernameFocus.hasFocus
                            ? AppColors.primaryColor.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Họ và tên',
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: usernameFocus.hasFocus
                              ? AppColors.primaryColor
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
                            ? AppColors.primaryColor.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.1),
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          focusColor: Colors.black,
                          filled: true, //<-- SEE HERE
                          fillColor: passwordFocus.hasFocus
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.1),
                              width: 2.0,
                            ),
                          ),
                          hintText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.password_outlined,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      focusNode: passwordConfirmFocus,
                      controller: passwordConfirm,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng nhập mật khẩu";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          focusColor: Colors.black,
                          filled: true, //<-- SEE HERE
                          fillColor: passwordConfirmFocus.hasFocus
                              ? AppColors.primaryColor.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: AppColors.primaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey.withOpacity(0.1),
                              width: 2.0,
                            ),
                          ),
                          hintText: 'Xác nhận mật khẩu',
                          prefixIcon: Icon(Icons.password_outlined,
                              color: passwordFocus.hasFocus
                                  ? AppColors.primaryColor
                                  : Colors.black),
                          suffixIcon: Icon(
                            Icons.lock_outline,
                            color: passwordConfirmFocus.hasFocus
                                ? AppColors.primaryColor
                                : Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                      child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<SignupCubit>(context).SignUp(
                            username.text,
                            email.text,
                            password.text,
                            passwordConfirm.text);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(25)),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Center(
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Bạn đã có tài khoản? ',
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => appRouter.push(const SignInViewRoute()),
                            text: 'Đăng nhập tại đây',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor),
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
    );
