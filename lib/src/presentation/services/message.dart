import 'dart:convert';
import 'package:http/http.dart';
import '../../config/url/config.dart';
import '../models/message.dart';

class MessageService {
  static Future<List<Message>> getMessageChatRoom(
    String chatRoomId,
  ) async {
    var uri = Uri.parse(urlGetMessage + "/" + chatRoomId);
    Response res = await post(
      uri,
    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      print(body);
      List<Message> messages =
          body.map((dynamic item) => Message.fromJson(item)).toList();

      for (var item in messages) {
        print(item.toJson());
      }

      return messages;
    } else {
      throw "Failed to load list";
    }
  }
}
