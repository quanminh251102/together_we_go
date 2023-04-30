// ignore_for_file: public_member_api_docs, sort_constructors_first
class DistanceMatrix {
  final String km;
  final String min;
  DistanceMatrix({
    required this.km,
    required this.min,
  });
  factory DistanceMatrix.fromJson(Map<String, dynamic> data) {
    return DistanceMatrix(
        km: data["distance"]["text"], min: data["duration"]["text"]);
  }
}
