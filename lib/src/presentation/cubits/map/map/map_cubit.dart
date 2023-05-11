import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/place_search.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(10, 10));
  // Set<Marker> markerList = {};
  Set<Circle> circles = {};
  List<PlaceSearch> placeSearchList = [];
  Position position = Position(
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
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14);
        // circles = Set.from([
        //   Circle(
        //       circleId: const CircleId("myCircle"),
        //       radius: 230,
        //       center: LatLng(position.latitude, position.longitude),
        //       fillColor: Colors.blue.shade100.withOpacity(0.5),
        //       strokeColor: Colors.blue.shade100.withOpacity(0.1),
        //       onTap: () {
        //         print('circle pressed');
        //       })
        // ]);
        // markerList = {
        //   Marker(
        //     markerId: const MarkerId('current_Postion'),
        //     infoWindow: const InfoWindow(title: 'Current Position'),
        //     position: LatLng(position.latitude, position.longitude),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(
        //       BitmapDescriptor.hueGreen,
        //     ),
        //   )
        // };
        emit(MapLoadSuccess(
          position: position,
          cameraPosition: cameraPosition,
        ));
      } else if (statusRequest.isPermanentlyDenied) {
        // Location permission has been permanently denied, navigate to app settings
        await openAppSettings();
      }
    } else if (status.isGranted) {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 20);
      // circles = Set.from([
      //   Circle(
      //       circleId: const CircleId("myCircle"),
      //       radius: 20,
      //       center: LatLng(position.latitude, position.longitude),
      //       fillColor: Colors.blue.shade100.withOpacity(0.5),
      //       strokeColor: Colors.blue.shade100.withOpacity(0.1),
      //       onTap: () {
      //         print('circle pressed');
      //       })
      // ]);
      // markerList = {
      //   Marker(
      //     markerId: const MarkerId('current_Postion'),
      //     infoWindow: const InfoWindow(title: 'Current Position'),
      //     position: LatLng(position.latitude, position.longitude),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(
      //       BitmapDescriptor.hueGreen,
      //     ),
      //   )
      // };
      emit(MapLoadSuccess(
        position: position,
        cameraPosition: cameraPosition,
      ));
    } else if (status.isPermanentlyDenied) {
      // Location permission has been permanently denied, navigate to app settings
      await openAppSettings();
    }
  }
}
