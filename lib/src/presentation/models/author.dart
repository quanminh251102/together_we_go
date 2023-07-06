class Author {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? avatarUrl;
  String? phoneNumber;
  bool? online;
  String? time;
  String? gender;
  String? locationAddress;
  String? locationId;
  String? locationMainText;
  String? birthDate;

  Author(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.avatarUrl,
      this.phoneNumber,
      this.online,
      this.time,
      this.gender,
      this.locationAddress,
      this.locationId,
      this.locationMainText,
      this.birthDate});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    avatarUrl = json['avatarUrl'];
    phoneNumber = json['phoneNumber'];
    online = json['online'];
    time = json['time'];
    gender = json['gender'];
    locationAddress = json['location_address'];
    locationId = json['location_id'];
    locationMainText = json['location_mainText'];
    birthDate = json['birth_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['avatarUrl'] = this.avatarUrl;
    data['phoneNumber'] = this.phoneNumber;
    data['online'] = this.online;
    data['time'] = this.time;
    data['gender'] = this.gender;
    data['location_address'] = this.locationAddress;
    data['location_id'] = this.locationId;
    data['location_mainText'] = this.locationMainText;
    data['birth_date'] = this.birthDate;

    return data;
  }
}
