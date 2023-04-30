// ignore_for_file: public_member_api_docs, sort_constructors_first
class Location {
  final String latitude;
  final String longitude;
  Location({required this.latitude, required this.longitude});
  factory Location.fromJson(Map<String, dynamic> data) {
    return Location(
        latitude: data['geometry']['location']['lat'].toString(),
        longitude: data['geometry']['location']['lng'].toString());
  }
}
