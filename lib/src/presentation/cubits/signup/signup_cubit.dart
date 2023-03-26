import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../../config/url/config.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());
  void SignUp(String username, String email, String password,
      String passwordConfirm) async {
    try {
      if (password != passwordConfirm) {
        emit(SignupError());
      } else {
        emit(SignupLoading());
        Response response = await post(Uri.parse(urlSignUp), body: {
          'first_name': username,
          'email': email,
          'password': password
        });
        print('Successfully registered');
        if (response.statusCode == 201) {
          print(email);
          print(password);
          emit(SignupSuccess(email));
        } else {
          print("Failed");
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
