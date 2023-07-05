import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import '../../../../models/booking.dart';

abstract class ITrackingRouteViewModel implements ChangeNotifier {
  Future<void> init(String applyId);
  Position get userLocation;
  List<LatLng> get coordinates;
  LatLngBounds? get bounds;
  List<Marker> get listMarker;
  Booking get currentBooking;
  bool get isLoading;
}
