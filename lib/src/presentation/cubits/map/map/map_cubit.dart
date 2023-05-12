import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  Position userLocation = Position(10.123456, 106.765432);
  geolocator.Position _userLocation = geolocator.Position(
      latitude: 10.123456,
      longitude: 106.765432,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  MapboxMap? mapboxMap;
  Future<void> requestLocationPermission() async {
    emit(MapLoading());
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      final statusRequest = await Permission.locationWhenInUse.request();
      if (statusRequest.isDenied) {
        emit(MapLoadError());
      } else if (statusRequest.isGranted) {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(enabled: true));
        _userLocation = await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high,
        );
        userLocation =
            Position(_userLocation.longitude, _userLocation.latitude);
        print('Location: ${userLocation}');

        emit(MapLoadSuccess(
          mapboxMap: mapboxMap,
          userLocation: userLocation,
        ));
      } else if (statusRequest.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (status.isGranted) {
      mapboxMap?.location
          .updateSettings(LocationComponentSettings(enabled: true));
      _userLocation = await geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high,
      );
      userLocation = Position(_userLocation.longitude, _userLocation.latitude);
      print('Location: ${userLocation}');

      emit(MapLoadSuccess(
        mapboxMap: mapboxMap,
        userLocation: userLocation,
      ));
    } else if (status.isPermanentlyDenied) {
      // Location permission has been permanently denied, navigate to app settings
      await openAppSettings();
    }
  }
}
