import 'dart:convert';
import 'package:http/http.dart';
import '../../config/url/config.dart';
import '../cubits/app_user.dart';
import '../models/chat_room.dart';

class ChatRoomService {
  static Future<List<ChatRoom>> getChatRoom(
    String chatRoomId,
  ) async {
    var uri = Uri.parse(urlGetChatRoom + "/" + appUser.id);
    Response res = await get(
      uri,
    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      print(body);
      List<ChatRoom> chat_rooms =
          body.map((dynamic item) => ChatRoom.fromJson(item)).toList();

      for (var item in chat_rooms) {
        print(item.toJson());
      }

      return chat_rooms;
    } else {
      throw "Failed to load list chat rooms";
    }
  }

  static Future<ChatRoom> getChatRoomInBooking(String posterId) async {
    var uri = Uri.parse(
        '$baseUrl/api/chat_room/getChatRoomInBooking/$posterId/${appUser.id}');

    print(
        '$baseUrl/api/chat_room/getChatRoomInBooking/$posterId/${appUser.id}');
    Response res = await get(
      uri,
    );

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      print(body);

      return ChatRoom.fromJson(body);
    } else {
      throw "error";
    }
  }
}
