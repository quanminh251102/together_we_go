import 'dart:convert';

import 'package:http/http.dart';

import '../../config/url/config.dart';

class ReviewService {
  static Future<String> createReview(Map<String, dynamic> _body) async {
    var uri = Uri.parse('$baseUrl/api/review');

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

  static Future<List<dynamic>> getReviewWithUserId(String userId) async {
    var uri = Uri.parse('$baseUrl/api/review/$userId');

    print('$baseUrl/api/review/$userId');
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
