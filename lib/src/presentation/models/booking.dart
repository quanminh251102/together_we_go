// ignore_for_file: public_member_api_docs, sort_constructors_first
class Booking {
  String authorId;
  String authorName;
  String authorAvatar;
  String price;
  final String bookingType; //
  final DateTime time;
  final String contact;
  final String content;
  final String startPoint;
  final String endPoint;
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
  });
  static toBooking(Map<String, dynamic> map) {
    return Booking(
        status: map["status"],
        authorId: map["authorId"],
        authorName: map["authorName"],
        price: map["price"],
        authorAvatar: map["authorAvatar"],
        bookingType: map["bookingType"],
        time: map["time"],
        contact: map["contact"],
        content: map["content"],
        startPoint: map["startPoint"],
        endPoint: map["endPoint"]);
  }

  static List<Booking> list = [
    Booking(
        authorId: '123',
        authorName: 'Lê Minh Quân',
        authorAvatar:
            'https://hinhnen4k.com/wp-content/uploads/2023/02/anh-gai-xinh-vn-2.jpg',
        bookingType: 'Tìm người chở',
        price: '10000',
        time: DateTime.now(),
        contact: '0987101231',
        content: 'Tìm người yêu để chở em đi chơi',
        startPoint: 'KTX khu B',
        endPoint: 'Khách sạn tình yêu',
        status: 'available'),
    Booking(
        authorId: '1234',
        authorName: 'Nguyễn Hoàng Kiệt',
        authorAvatar:
            'https://hinhnen4k.com/wp-content/uploads/2023/02/anh-gai-xinh-vn-2.jpg',
        bookingType: 'Tìm người chở',
        price: '10000',
        time: DateTime.now(),
        contact: '0987101231',
        content: 'Tìm người yêu để chở em đi chơi',
        startPoint: 'KTX khu B',
        endPoint: 'Khách sạn tình yêu',
        status: 'available'),
  ];
}
