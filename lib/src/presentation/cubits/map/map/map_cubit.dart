// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert' as convert;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:permission_handler/permission_handler.dart';

import '../../../../config/url/config.dart';
import '../../../../utils/constants/colors.dart';
import '../../../models/booking.dart';
import '../../../views/common_widget/user_marker.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  List<Marker> listMarker = [];
  List<Marker> listSelectedMarker = [];
  List<LatLng> coordinates = [];
  late LatLngBounds bounds;

  Position userLocation = Position(
      latitude: 10.123456,
      longitude: 106.765432,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  Future<void> requestLocationPermission() async {
    emit(MapLoading());
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      final statusRequest = await Permission.locationWhenInUse.request();
      if (statusRequest.isDenied) {
        emit(MapLoadError());
      } else if (statusRequest.isGranted) {
        var result = await http.get(
          Uri.parse(urlGetListBooking),
        );
        if (result.statusCode == 200) {
          List<dynamic> data = convert.jsonDecode(result.body) as List<dynamic>;
          List<Booking> bookingAvailable = [];

          for (int i = 0; i < data.length; i++) {
            if (data[i]['status'] == 'available') {
              bookingAvailable.add(Booking.toBooking(data[i]));
            }
          }
          userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          listMarker.add(Marker(
            point:
                latlong2.LatLng(userLocation.latitude, userLocation.longitude),
            width: 60,
            height: 60,
            builder: (context) {
              return const UserMarker();
            },
          ));
          for (var book in bookingAvailable) {
            listMarker.add(
              Marker(
                point: latlong2.LatLng(double.parse(book.startPointLat),
                    double.parse(book.startPointLong)),
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      emit(MapLoading());
                      coordinates = [
                        LatLng(double.parse(book.startPointLat),
                            double.parse(book.startPointLong)),
                        LatLng(double.parse(book.endPointLat),
                            double.parse(book.endPointLong))
                      ];
                      bounds = LatLngBounds.fromPoints(coordinates
                          .map((location) => latlong2.LatLng(
                              location.latitude, location.longitude))
                          .toList());
                      listSelectedMarker.add(Marker(
                        point: latlong2.LatLng(double.parse(book.startPointLat),
                            double.parse(book.startPointLong)),
                        builder: (context) {
                          return Transform.scale(
                            scale: 1,
                            child: SvgPicture.asset(
                              'assets/svg/start.svg',
                            ),
                          );
                        },
                      ));
                      listSelectedMarker.add(Marker(
                        point: latlong2.LatLng(double.parse(book.endPointLat),
                            double.parse(book.endPointLong)),
                        builder: (context) {
                          return Transform.scale(
                            scale: 1,
                            child: SvgPicture.asset(
                              'assets/svg/end.svg',
                            ),
                          );
                        },
                      ));
                      emit(MapShowDetail(
                          coordinates: coordinates,
                          bounds: bounds,
                          listMarkers: listSelectedMarker,
                          book: book));
                    },
                    icon: Transform.scale(
                      scale: 2,
                      child: SvgPicture.asset(
                        'assets/svg/pin.svg',
                      ),
                    ),
                  );
                },
              ),
            );
          }

          emit(MapLoadSuccess(
            listMarkers: listMarker,
            userLocation: userLocation,
          ));
        } else {
          emit(MapLoadError());
        }
      } else if (statusRequest.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (status.isGranted) {
      var result = await http.get(
        Uri.parse(urlGetListBooking),
      );
      if (result.statusCode == 200) {
        List<dynamic> data = convert.jsonDecode(result.body) as List<dynamic>;
        List<Booking> bookingAvailable = [];

        for (int i = 0; i < data.length; i++) {
          if (data[i]['status'] == 'available') {
            bookingAvailable.add(Booking.toBooking(data[i]));
          }
        }
        userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        listMarker.add(Marker(
          point: latlong2.LatLng(userLocation.latitude, userLocation.longitude),
          width: 60,
          height: 60,
          builder: (context) {
            return const UserMarker();
          },
        ));
        for (var book in bookingAvailable) {
          listMarker.add(
            Marker(
              point: latlong2.LatLng(double.parse(book.startPointLat),
                  double.parse(book.startPointLong)),
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    emit(MapLoading());
                    coordinates = [
                      LatLng(double.parse(book.startPointLat),
                          double.parse(book.startPointLong)),
                      LatLng(double.parse(book.endPointLat),
                          double.parse(book.endPointLong))
                    ];
                    bounds = LatLngBounds.fromPoints(coordinates
                        .map((location) => latlong2.LatLng(
                            location.latitude, location.longitude))
                        .toList());
                    listSelectedMarker.add(Marker(
                      point: latlong2.LatLng(double.parse(book.startPointLat),
                          double.parse(book.startPointLong)),
                      builder: (context) {
                        return Transform.scale(
                          scale: 1,
                          child: SvgPicture.asset(
                            'assets/svg/start.svg',
                          ),
                        );
                      },
                    ));
                    listSelectedMarker.add(Marker(
                      point: latlong2.LatLng(double.parse(book.endPointLat),
                          double.parse(book.endPointLong)),
                      builder: (context) {
                        return Transform.scale(
                          scale: 1,
                          child: SvgPicture.asset(
                            'assets/svg/end.svg',
                          ),
                        );
                      },
                    ));
                    emit(MapShowDetail(
                        coordinates: coordinates,
                        bounds: bounds,
                        listMarkers: listSelectedMarker,
                        book: book));
                  },
                  icon: Transform.scale(
                    scale: 2,
                    child: SvgPicture.asset(
                      'assets/svg/pin.svg',
                    ),
                  ),
                );
              },
            ),
          );
        }
        emit(MapLoadSuccess(
          listMarkers: listMarker,
          userLocation: userLocation,
        ));
      }
    } else if (status.isPermanentlyDenied) {
      // Location permission has been permanently denied, navigate to app settings
      await openAppSettings();
    }
  }

  Future<void> backtoInitial() async {
    listSelectedMarker = [];
    await requestLocationPermission();
  }
}
