import 'dart:convert';

import 'package:http/http.dart';

import '../../config/url/config.dart';
import '../cubits/app_user.dart';

class ApplyService {
  static Future<String> createApply(Map<String, dynamic> _body) async {
    var uri = Uri.parse('$baseUrl/api/apply');

    print('');
    Response res = await post(
      uri,
      body: _body,
    );

    if (res.statusCode == 200) {
      return "pass";
    } else {
      return "error";
    }
  }

  static Future<List<dynamic>> getMyApply() async {
    var uri = Uri.parse('$baseUrl/api/apply/getMyApply/${appUser.id}');

    print('$baseUrl/api/apply/getMyApply/${appUser.id}');
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

  static Future<List<dynamic>> getApplyInBooking(String bookingId) async {
    var uri = Uri.parse('$baseUrl/api/apply/getApplyBooking/${bookingId}');

    print('$baseUrl/api/apply/getApplyBooking/${bookingId}');
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

  static Future<String> update(
      String applyId, Map<String, dynamic> _body) async {
    var uri = Uri.parse('$baseUrl/api/apply/${applyId}');

    print('$baseUrl/api/apply/${applyId}');
    Response res = await patch(uri, body: _body);

    if (res.statusCode == 200) {
      return "pass";
    } else {
      return "error";
    }
  }
}
