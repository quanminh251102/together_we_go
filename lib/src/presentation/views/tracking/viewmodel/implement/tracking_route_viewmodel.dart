import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../config/url/config.dart';
import '../../../../cubits/map/map/map_cubit.dart';
import '../../../../models/booking.dart';
import '../../../common_widget/user_marker.dart';
import '../interfaces/itracking_route_viewmodel.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:flutter_map_directions/flutter_map_directions.dart'
    as flutter_map_directions;

class TrackingRouteViewModel
    with ChangeNotifier
    implements ITrackingRouteViewModel {
  bool _isLoading = true;
  @override
  bool get isLoading => _isLoading;

  Position _userLocation = Position(
      latitude: 10.123456,
      longitude: 106.765432,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  @override
  Position get userLocation => _userLocation;
  List<flutter_map_directions.LatLng> _coordinates = [];
  @override
  List<flutter_map_directions.LatLng> get coordinates => _coordinates;

  LatLngBounds? _bounds;
  @override
  LatLngBounds? get bounds => _bounds;

  List<Marker> _listMarker = [];
  @override
  List<Marker> get listMarker => _listMarker;

  Booking _currentBooking = Booking(
      id: '',
      authorId: '',
      authorName: '',
      authorAvatar: '',
      price: '',
      bookingType: '',
      time: '',
      contact: '',
      content: '',
      startPointId: '',
      startPointLat: '',
      startPointLong: '',
      startPointMainText: '',
      startPointAddress: '',
      endPointLat: '',
      endPointLong: '',
      endPointId: '',
      endPointMainText: '',
      endPointAddress: '',
      status: '',
      distance: '',
      duration: '');
  @override
  Booking get currentBooking => _currentBooking;

  @override
  Future<void> init(String applyId) async {
    _listMarker = [];
    _coordinates = [];
    _userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    await getBookingInApply(applyId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getBookingInApply(String applyId) async {
    try {
      var result = await http.get(
        Uri.parse('$urlGetBookingInApply/$applyId'),
      );
      if (result.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(result.body);
        _currentBooking =
            Booking.toBooking(data["booking"] as Map<String, dynamic>);
        _coordinates = [
          flutter_map_directions.LatLng(
              double.parse(_currentBooking.startPointLat),
              double.parse(_currentBooking.startPointLong)),
          flutter_map_directions.LatLng(
              double.parse(_currentBooking.endPointLat),
              double.parse(_currentBooking.endPointLong))
        ];
        _bounds = LatLngBounds.fromPoints(_coordinates
            .map((location) =>
                latlong2.LatLng(location.latitude, location.longitude))
            .toList());

        listMarker.add(Marker(
          point: latlong2.LatLng(double.parse(_currentBooking.startPointLat),
              double.parse(_currentBooking.startPointLong)),
          builder: (context) {
            return Transform.scale(
              scale: 1,
              child: SvgPicture.asset(
                'assets/svg/start.svg',
              ),
            );
          },
        ));
        listMarker.add(Marker(
          point: latlong2.LatLng(double.parse(_currentBooking.endPointLat),
              double.parse(_currentBooking.endPointLong)),
          builder: (context) {
            return Transform.scale(
              scale: 1,
              child: SvgPicture.asset(
                'assets/svg/end.svg',
              ),
            );
          },
        ));

        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
