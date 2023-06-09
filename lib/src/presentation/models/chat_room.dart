class ChatRoom {
  String id;
  String partner_name;
  String partner_gmail;
  String partner_avatar;
  String partner_id;
  int numUnWatch;
  Map<String, dynamic> lastMessage;

  ChatRoom({
    required this.id,
    required this.partner_name,
    required this.partner_gmail,
    required this.partner_avatar,
    required this.partner_id,
    required this.numUnWatch,
    required this.lastMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_name': partner_name,
      'partner_gmail': partner_gmail,
      'partner_avatar': partner_avatar,
      'partner_id': partner_id,
      'numUnWatch': numUnWatch,
      'lastMessage': lastMessage,
    };
  }

  ChatRoom.fromJson(Map<String, dynamic> body)
      : id = body['id'] == null ? '' : body['id'],
        partner_name = body['partner_name'] == null ? '' : body['partner_name'],
        partner_gmail =
            body['partner_gmail'] == null ? '' : body['partner_gmail'],
        partner_avatar =
            body['partner_avatar'] == null ? '' : body['partner_avatar'],
        partner_id = body['partner_id'] == null ? '' : body['partner_id'],
        numUnWatch = body['num_unwatch'],
        lastMessage = body['lastMessage'];
}
