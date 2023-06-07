import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/url/config.dart';
import '../app_user.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoggedIn = false;
  late GoogleSignInAccount _userObj;
  late FacebookLogin pluginFacebook = FacebookLogin();

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

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);

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

  void SignInWithFacebook() async {
    try {
      // Create an instance of FacebookLogin
      //this.pluginFacebook = new FacebookLogin();
      await this.pluginFacebook.logOut();
// Log in
      final res = await this.pluginFacebook.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      emit(SigninLoading());

// Check result status
      switch (res.status) {
        case FacebookLoginStatus.success:
          // Logged in

          // Send access token to server for validation and auth
          final FacebookAccessToken accessToken = res.accessToken!;
          print('date ${accessToken.expires}');
          print('Access token: ${accessToken.token}');

          // Get profile data
          final profile = await this.pluginFacebook.getUserProfile();
          print('Hello, ${profile?.name}! You ID: ${profile?.userId}');

          // Get user profile image url
          final imageUrl =
              await this.pluginFacebook.getProfileImageUrl(width: 100);
          print('Your profile image: $imageUrl');

          // Get email (since we request email permission)
          final email = await this.pluginFacebook.getUserEmail();
          // But user can decline permission
          if (email != null) print('And your email is $email');

          Response response =
              await post(Uri.parse('$baseUrl/api/auth/loginWithGoogle'), body: {
            'email': '${profile?.userId}',
            'name': profile?.name,
            'avatar': imageUrl,
          });
          print('Successfully Login Facebook');
          print(response.body);
          if (response.statusCode == 200) {
            final new_t = response.body;
            final data = json.decode(new_t) as Map<String, dynamic>;

            appUser.init(data["user_id"], data["user_name"], data["user_email"],
                data["user_avatar"]);

            emit(SigninSuccess(''));
          } else {
            print("Failed");
            emit(SigninError('Đã xảy ra lổi phía server'));
          }
          break;
        case FacebookLoginStatus.cancel:
          // User cancel log in
          emit(SigninError('Đã xảy ra lổi khi xác thực facebook'));
          break;
        case FacebookLoginStatus.error:
          // Log in failed
          print('Error while log in: ${res.error}');
          emit(SigninError('Đã xảy ra lổi khi xác thực facebook'));
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  void Logout() async {
    emit(SigninLoading());
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('password');
    _googleSignIn.signOut().then((value) {
      _isLoggedIn = false;
    }).catchError((e) {});

    await this.pluginFacebook.logOut();

    print(
        'logout ${await this.pluginFacebook.getUserEmail()} ${await this.pluginFacebook.isLoggedIn}');

    emit(SigninInitial());
  }
}
