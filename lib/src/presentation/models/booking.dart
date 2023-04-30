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
  final String startPointMainText;
  final String startPointAddress;
  final String endPointMainText;
  final String endPointAddress;
  final String status;
  final String distance;
  final String duration;
  Booking({
    required this.authorId,
    required this.authorName,
    required this.authorAvatar,
    required this.price,
    required this.bookingType,
    required this.time,
    required this.contact,
    required this.content,
    required this.startPointMainText,
    required this.startPointAddress,
    required this.endPointMainText,
    required this.endPointAddress,
    required this.status,
    required this.distance,
    required this.duration,
  });
  static toBooking(Map<String, dynamic> map) {
    return Booking(
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
      startPointMainText: map["startPointMainText"],
      startPointAddress: map["startPointAddress"],
      endPointAddress: map["endPointAddress"],
      endPointMainText: map["endPointMainText"],
    );
  }
}
