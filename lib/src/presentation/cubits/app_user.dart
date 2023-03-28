class AppUser {
  late String _id;
  String get id => _id;

  late String _name;
  String get name => _name;

  late String _gmail;
  String get gmail => _gmail;

  init(String id, String name, String gmail) {
    _id = id;
    _name = name;
    _gmail = gmail;
    print("Set app user");
    print("id: " + _id);
    print("name: " + _name);
    print("gmail: " + _gmail);
  }
}

final appUser = AppUser();
