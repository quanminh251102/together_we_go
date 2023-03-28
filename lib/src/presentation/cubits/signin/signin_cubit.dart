import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../../config/url/config.dart';
import '../app_user.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());
  void SignIn(
    String email,
    String password,
  ) async {
    try {
      emit(SigninLoading());
      Response response = await post(Uri.parse(urlLogin),
          body: {'email': email, 'password': password});
      print('Successfully Login');
      print(response.body);
      if (response.statusCode == 200) {
        final new_t = response.body;
        //final new_t = json.encode(jsonData);
        final data = json.decode(new_t) as Map<String, dynamic>;

        appUser.init(data["user_id"], data["user_name"], data["user_email"]);

        print(email);
        print(password);
        emit(SigninSuccess(email));
      } else {
        print("Failed");
        emit(SigninError());
      }
    } catch (e) {
      print(e);
    }
  }
}
