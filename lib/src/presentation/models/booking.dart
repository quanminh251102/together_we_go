// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'author.dart';

class Booking {
  String id;
  String authorId;
  String authorName;
  String authorAvatar;
  String price;
  final String bookingType; //
  final String time;
  final String contact;
  final String content;
  final String startPointId;
  final String startPointLat;
  final String startPointLong;
  final String startPointMainText;
  final String startPointAddress;
  final String endPointLat;
  final String endPointLong;
  final String endPointId;
  final String endPointMainText;
  final String endPointAddress;
  final String status;
  final String distance;
  final String duration;
  Author? accountDetail;
  Booking(
      {required this.id,
      required this.authorId,
      required this.authorName,
      required this.authorAvatar,
      required this.price,
      required this.bookingType,
      required this.time,
      required this.contact,
      required this.content,
      required this.startPointId,
      required this.startPointLat,
      required this.startPointLong,
      required this.startPointMainText,
      required this.startPointAddress,
      required this.endPointLat,
      required this.endPointLong,
      required this.endPointId,
      required this.endPointMainText,
      required this.endPointAddress,
      required this.status,
      required this.distance,
      required this.duration,
      this.accountDetail});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['status'] = this.status;
    data['price'] = this.price;
    data['bookingType'] = this.bookingType;
    data['time'] = this.time;
    data['content'] = this.content;
    data['startPointLat'] = this.startPointLat;
    data['startPointLong'] = this.startPointLong;
    data['startPointId'] = this.startPointId;
    data['startPointMainText'] = this.startPointMainText;
    data['startPointAddress'] = this.startPointAddress;
    data['endPointLat'] = this.endPointLat;
    data['endPointLong'] = this.endPointLong;
    data['endPointId'] = this.endPointId;
    data['endPointMainText'] = this.endPointMainText;
    data['endPointAddress'] = this.endPointAddress;
    data['distance'] = this.distance;
    data['duration'] = this.duration;
    data['authorId'] = this.accountDetail!.toJson();
    return data;
  }

  static toBooking(Map<String, dynamic> map) {
    return Booking(
        id: map["_id"],
        distance: map["distance"],
        duration: map["duration"],
        status: map["status"],
        authorId: map["authorId"]["_id"],
        authorName: map["authorId"]["first_name"],
        price: map["price"].toString(),
        authorAvatar: map["authorId"]["avatarUrl"],
        bookingType: map["bookingType"],
        time: map["time"],
        contact: map["authorId"]["phoneNumber"] ?? " ",
        content: map["content"],
        startPointLat: map["startPointLat"],
        startPointLong: map["startPointLong"],
        startPointMainText: map["startPointMainText"],
        startPointAddress: map["startPointAddress"],
        endPointLat: map["endPointLat"],
        endPointLong: map["endPointLong"],
        endPointAddress: map["endPointAddress"],
        endPointMainText: map["endPointMainText"],
        endPointId: map["endPointId"],
        startPointId: map["startPointId"],
        accountDetail: map['authorId'] != null
            ? new Author.fromJson(map['authorId'])
            : null);
  }

  static toAuthor(Map<String, dynamic> map) {
    return Author(
        id: map["authorId"]["_id"],
        avatarUrl: map['authorId']['avatarUrl'],
        birthDate: map['authorId']['birth_date'],
        email: map['authorId']['email'],
        firstName: map['authorId']['first_name'],
        lastName: map['authorId']['last_name'],
        gender: map['authorId']['gender'],
        locationAddress: map['authorId']['location_address'],
        locationId: map['authorId']['location_id'],
        locationMainText: map['authorId']['location_mainText'],
        online: map['authorId']['online'],
        password: map['authorId']['password'],
        phoneNumber: map['authorId']['phoneNumber'],
        time: map['authorId']['time']);
  }
}
