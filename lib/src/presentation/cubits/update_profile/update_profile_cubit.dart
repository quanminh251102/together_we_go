import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../../../config/router/app_router.dart';
import '../../../config/url/config.dart';
import '../app_user.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  void navigateToUpdateProfileScreen(Function cancel_loading) async {
    // Map<String, dynamic> user = {
    //   "name": "kiet",
    //   "birth_date": "111111",
    //   "gender": "male",
    // };
    try {
      Response response =
          await get(Uri.parse('$baseUrl/api/user/get_user/${appUser.id}'));
      print(response.body);
      if (response.statusCode == 200) {
        final new_t = response.body;
        final data = json.decode(new_t) as Map<String, dynamic>;

        appRouter.push(UpdateProfilePageRoute(user: data));
      } else {
        print("Failed");
      }
    } catch (e) {
      print(e);
    }

    cancel_loading();
  }

  void update_user(
    Map<String, dynamic> user,
    Function function_pass,
    Function function_error,
  ) async {
    appUser.edit_name(user["name"]);

    try {
      Response response = await patch(
          Uri.parse('$baseUrl/api/user/update_user/${appUser.id}'),
          body: {
            "name": user["name"],
            "gender": user["gender"],
            "birth_date": user["birth_date"],
          });
      print(response.body);
      if (response.statusCode == 200) {
        function_pass();
      } else {
        print("Failed");
        function_error();
      }
    } catch (e) {
      print(e);
      function_error();
    }
  }
}
