import 'package:http/http.dart';

import '../../config/url/config.dart';

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
}
