import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../../config/url/config.dart';

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
      if (response.statusCode == 200) {
        print(email);
        print(password);
        emit(SigninSuccess(email));
      } else {
        print("Failed");
      }
    } catch (e) {
      print(e);
    }
  }
}
