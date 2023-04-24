import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../config/url/config.dart';
import '../app_user.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;

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

        appUser.init(data["user_id"], data["user_name"], data["user_email"],
            data["user_avatar"]);

        print(email);
        print(password);
        emit(SigninSuccess(email));
      } else {
        print("Failed");
        emit(SigninError('Đã xảy ra lổi, vui lòng đăng nhập lại'));
      }
    } catch (e) {
      print(e);
    }
  }

  void SignInWithGoogle() async {
    try {
      _googleSignIn.signIn().then((userData) async {
        if (userData == null) return;

        emit(SigninLoading());
        _isLoggedIn = true;
        _userObj = userData;
        var avatar = _userObj.photoUrl!;
        var name = _userObj.displayName!;
        var email = _userObj.email;
        print("KIET $avatar $email $name");
        Response response =
            await post(Uri.parse('$baseUrl/api/auth/loginWithGoogle'), body: {
          'email': email,
          'name': name,
          'avatar': avatar,
        });
        print('Successfully Login Google');
        print(response.body);
        if (response.statusCode == 200) {
          final new_t = response.body;
          //final new_t = json.encode(jsonData);
          final data = json.decode(new_t) as Map<String, dynamic>;

          appUser.init(data["user_id"], data["user_name"], data["user_email"],
              data["user_avatar"]);

          // print(email);
          // print(password);
          emit(SigninSuccess(email));
        } else {
          print("Failed");
          emit(SigninError('Đã xảy ra lổi, vui lòng đăng nhập lại'));
        }
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  void Logout() {
    _googleSignIn.signOut().then((value) {
      _isLoggedIn = false;
    }).catchError((e) {});
  }
}
