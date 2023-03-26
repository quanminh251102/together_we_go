import 'dart:convert';
import 'package:http/http.dart';
import '../models/message.dart';
//import '../../../config/config.dart' as config;

final chatUrl = 'http://192.168.1.19:8080/api/message/641dc278b35f299b2b12b2ea';

class MessageService {
  static Future<List<Message>> getMessageChatRoom(
    String chatRoomId,
  ) async {
    //var uri = Uri.parse(config.urlGetMessageChatRoom + chatRoomId);
    var uri = Uri.parse(chatUrl);
    //print(config.urlGetMessageChatRoom + chatRoomId);
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
