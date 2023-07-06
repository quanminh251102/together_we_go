import 'dart:convert';

import 'package:http/http.dart';

import '../../config/url/config.dart';
import '../cubits/app_user.dart';

class BookingService {
  static Future<List<dynamic>> getMyBooking() async {
    var uri = Uri.parse('$baseUrl/api/booking/getMyBooking/${appUser.id}');

    print('$baseUrl/api/booking/getMyBooking/${appUser.id}');
    Response res = await get(
      uri,
    );

    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
      List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data;
    } else {
      throw "error";
    }
  }

  static Future<List<dynamic>> getBookingWithId(String userId) async {
    var uri = Uri.parse('$baseUrl/api/booking/getMyBooking/${userId}');
    Response res = await get(
      uri,
    );

    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
      List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data;
    } else {
      throw "error";
    }
  }

  static Future<List<dynamic>> getMyCompleteBooking(String userId) async {
    var uri = Uri.parse('$baseUrl/api/booking/getMyCompleteBooking/${userId}');
    Response res = await get(
      uri,
    );

    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
      List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
      return data;
    } else {
      throw "error";
    }
  }
}
