import 'dart:convert';
import 'package:http/http.dart';
import '../../config/url/config.dart';
import '../cubits/app_user.dart';

class UserService {
  static Future<void> editAvatar(
    String avatar_url,
  ) async {
    var uri = Uri.parse(urlEditAvatar + "/" + appUser.id);
    print(urlEditAvatar + "/" + appUser.id);
    Response res = await post(uri, body: {
      'avatar_url': avatar_url,
    });

    if (res.statusCode == 200) {
      print("Ok to edit avatar");
    } else {
      throw "Failed to edit avatar";
    }
  }
}
