import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../models/place_search.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  CameraPosition cameraPosition = CameraPosition(target: LatLng(10, 10));
  Set<Marker> markerList = {};
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
        circles = Set.from([
          Circle(
              circleId: CircleId("myCircle"),
              radius: 230,
              center: LatLng(position.latitude, position.longitude),
              fillColor: Colors.blue.shade100.withOpacity(0.5),
              strokeColor: Colors.blue.shade100.withOpacity(0.1),
              onTap: () {
                print('circle pressed');
              })
        ]);
        markerList = {
          Marker(
            markerId: MarkerId('current_Postion'),
            infoWindow: InfoWindow(title: 'Current Position'),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          )
        };
        emit(MapLoadSuccess(
            position: position,
            cameraPosition: cameraPosition,
            circles: circles,
            markers: markerList));
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
      circles = Set.from([
        Circle(
            circleId: CircleId("myCircle"),
            radius: 20,
            center: LatLng(position.latitude, position.longitude),
            fillColor: Colors.blue.shade100.withOpacity(0.5),
            strokeColor: Colors.blue.shade100.withOpacity(0.1),
            onTap: () {
              print('circle pressed');
            })
      ]);
      markerList = {
        Marker(
          markerId: MarkerId('current_Postion'),
          infoWindow: InfoWindow(title: 'Current Position'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        )
      };
      emit(MapLoadSuccess(
        markers: markerList,
        position: position,
        cameraPosition: cameraPosition,
        circles: circles,
      ));
    } else if (status.isPermanentlyDenied) {
      // Location permission has been permanently denied, navigate to app settings
      await openAppSettings();
    }
  }
}
