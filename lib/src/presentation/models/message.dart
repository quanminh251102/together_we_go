class Message {
  String message;
  String userId;
  String chatRoomId;
  String type;
  String? createdAt;

  Message({
    required this.message,
    required this.userId,
    required this.type,
    this.createdAt,
    required this.chatRoomId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userId': userId,
      'chatRoomId': chatRoomId,
      'type': type,
    };
  }

  // Message.fromJson(Map<String, dynamic> body)
  //     : message = body['message'] == null ? '' : body['message'],
  //       userId = body['userId'] == null ? '' : body['userId'],
  //       chatRoomId = body['chatRoomId'] == null ? '' : body['chatRoomId'],
  //       type = body['type'] == null ? '' : body['type'],
  //       createdAt = body['createdAt'] == null
  //           ? ''
  //           : DateTime.parse(body['createdAt'] as String)
  //               .toLocal()
  //               .toString()
  //               .substring(11, 16);

  Message.fromJson(Map<String, dynamic> body)
      : message = body['message'] == null ? '' : body['message'],
        userId = body['userId'] == null ? '' : body['userId'],
        chatRoomId = body['chatRoomId'] == null ? '' : body['chatRoomId'],
        type = body['type'] == null ? '' : body['type'],
        createdAt =
            body['createdAt'] == null ? '' : body['createdAt'] as String;
}
