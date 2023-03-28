class ChatRoom {
  String id;
  String partner_name;
  String partner_gmail;

  ChatRoom({
    required this.id,
    required this.partner_name,
    required this.partner_gmail,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'partner_name': partner_name,
      'partner_gmail': partner_gmail,
    };
  }

  ChatRoom.fromJson(Map<String, dynamic> body)
      : id = body['id'] == null ? '' : body['id'],
        partner_name = body['partner_name'] == null ? '' : body['partner_name'],
        partner_gmail =
            body['partner_gmail'] == null ? '' : body['partner_name'];
}
