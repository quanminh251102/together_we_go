class AppUser {
  late String _id;
  String get id => _id;

  late String _name;
  String get name => _name;

  late String _gmail;
  String get gmail => _gmail;

  late String _avatar;
  String get avatar => _avatar;

  init(String id, String name, String gmail, String avatar) {
    _id = id;
    _name = name;
    _gmail = gmail;
    _avatar = avatar;
    print("Set app user");
    print("id: " + _id);
    print("name: " + _name);
    print("gmail: " + _gmail);
    print("avatar: " + _avatar);
  }

  edit_avatar(String url) {
    _avatar = url;
  }
}

final appUser = AppUser();
