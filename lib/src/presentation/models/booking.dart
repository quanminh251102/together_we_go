// ignore_for_file: public_member_api_docs, sort_constructors_first
class Booking {
  String authorId;
  String authorName;
  String authorAvatar;
  String price;
  final String bookingType; //
  final String time;
  final String contact;
  final String content;
  final String startPoint;
  final String startPointAddress;
  final String endPoint;
  final String endPointAddress;
  final String status;
  Booking({
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.price,
    required this.bookingType,
    required this.time,
    required this.contact,
    required this.content,
    required this.startPoint,
    required this.endPoint,
    required this.status,
    required this.startPointAddress,
    required this.endPointAddress,
  });
  static toBooking(Map<String, dynamic> map) {
    return Booking(
        status: map["status"],
        authorId: map["authorId"]["_id"],
        authorName: map["authorId"]["first_name"],
        price: map["price"].toString(),
        authorAvatar: map["authorId"]["avatarUrl"],
        bookingType: map["bookingType"],
        time: map["time"],
        contact: map["authorId"]["phoneNumber"] ?? " ",
        content: map["content"],
        startPoint: map["startPoint"],
        startPointAddress: map["startPointAddress"],
        endPointAddress: map["endPointAddress"],
        endPoint: map["endPoint"]);
  }
}
