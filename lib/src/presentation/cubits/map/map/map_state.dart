// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoadSuccess extends MapState {
  final Position userLocation;
  final List<Marker> listMarkers;
  MapLoadSuccess({
    required this.userLocation,
    required this.listMarkers,
  });
}

class SearchPlace extends MapState {}

class MapLoadError extends MapState {}
