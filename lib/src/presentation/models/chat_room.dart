class ChatRoom {
  String id;
  String partner_name;
  String partner_gmail;
  String partner_avatar;

  ChatRoom({
    required this.id,
    required this.partner_name,
    required this.partner_gmail,
    required this.partner_avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_name': partner_name,
      'partner_gmail': partner_gmail,
      'partner_avatar': partner_avatar,
    };
  }

  ChatRoom.fromJson(Map<String, dynamic> body)
      : id = body['id'] == null ? '' : body['id'],
        partner_name = body['partner_name'] == null ? '' : body['partner_name'],
        partner_gmail =
            body['partner_gmail'] == null ? '' : body['partner_name'],
        partner_avatar =
            body['partner_avatar'] == null ? '' : body['partner_avatar'];
}
