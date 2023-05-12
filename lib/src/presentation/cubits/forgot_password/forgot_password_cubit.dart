import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../config/router/app_router.dart';
import '../../../config/url/config.dart';
import '../../../utils/showSnackbar.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  bool isEmailVerified = false;
  String email = '';
  late Timer timer;

  void init() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.signOut().then((value) {
      // Sign-out successful.
    }).catchError((error) {
      // An error happened.
    });

    emit(ForgotPasswordInitial());
    this.isEmailVerified = false;
    emit(ForgotPasswordLoaded(
        isEmailVerified: false, canEmailSend: true, status: ''));
  }

  void sendEmail(String email, BuildContext context) async {
    this.email = email;
    emit(ForgotPasswordInitial());
    emit(ForgotPasswordLoaded(
        isEmailVerified: false, canEmailSend: false, status: ''));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: 'firebase_default_password',
      );
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: 'firebase_default_password',
        );

        await FirebaseAuth.instance.currentUser?.delete();

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: 'firebase_default_password',
        );
        await sendEmailVerification(context);
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }

    this.timer = Timer.periodic(
        Duration(seconds: 3), (_) => checkEmailVirified(email, context));

    emit(ForgotPasswordInitial());
    emit(ForgotPasswordLoaded(
        isEmailVerified: false, canEmailSend: true, status: ''));
  }

  void checkEmailVirified(String email, BuildContext context) async {
    await FirebaseAuth.instance.currentUser!.reload();
    this.isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (this.isEmailVerified) {
      emit(ForgotPasswordInitial());

      this.isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      this.timer?.cancel();
      showSnackBar(context, 'Xác thực thành công');
      emit(ForgotPasswordLoaded(
          isEmailVerified: this.isEmailVerified,
          canEmailSend: true,
          status: ''));
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  void resetPassword(String password, BuildContext context) async {
    try {
      emit(ForgotPasswordLoading());
      Response response =
          await post(Uri.parse('$baseUrl/api/auth/resetPassword'), body: {
        'email': '${this.email}',
        'password': password,
      });
      print('Successfully reset Password');

      if (response.statusCode == 200) {
        print('reset password pass');

        emit(ForgotPasswordLoaded(
            isEmailVerified: this.isEmailVerified,
            canEmailSend: true,
            status: 'pass'));
      } else {
        emit(ForgotPasswordLoaded(
            isEmailVerified: this.isEmailVerified,
            canEmailSend: true,
            status: 'error'));
      }
    } catch (e) {
      print(e);
    }
  }
}
