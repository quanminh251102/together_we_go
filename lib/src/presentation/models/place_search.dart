// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlaceSearch {
  final String description;
  final String mainText;
  final String placeId;
  final String secondaryText;
  PlaceSearch({
    required this.description,
    required this.mainText,
    required this.placeId,
    required this.secondaryText,
  });
  factory PlaceSearch.fromJson(Map<String, dynamic> data) {
    return PlaceSearch(
        description: data['description'],
        placeId: data['place_id'],
        mainText: data['structured_formatting']['main_text'],
        secondaryText: data['structured_formatting']['secondary_text']);
  }
}
