// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_map_cubit.dart';

abstract class SearchMapState extends Equatable {
  const SearchMapState();

  @override
  List<Object> get props => [];
}

class SearchMapInitial extends SearchMapState {}

class SearchMapLoading extends SearchMapState {}

class SearchMapDoneSearch extends SearchMapState {
  final Widget imageRoute;
  SearchMapDoneSearch({
    required this.imageRoute,
  });
}

class SearchMaping extends SearchMapState {
  final List<PlaceSearch> placeSearchList;
  SearchMaping({
    required this.placeSearchList,
  });
}

class SearchMapError extends SearchMapState {}
