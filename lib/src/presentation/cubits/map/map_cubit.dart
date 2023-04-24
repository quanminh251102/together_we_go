import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  Future<void> requestLocationPermission() async {
    emit(MapLoading());
    final status = await Permission.locationWhenInUse.status;
    if (status.isDenied) {
      final statusRequest = await Permission.locationWhenInUse.request();
      if (statusRequest.isDenied) {
        emit(MapLoadError());
      } else if (statusRequest.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        CameraPosition cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14);
        Set<Circle> circles = Set.from([
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
        Set<Marker> markerList = {
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
        ));
      } else if (statusRequest.isPermanentlyDenied) {
        // Location permission has been permanently denied, navigate to app settings
        await openAppSettings();
      }
    } else if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 20);
      Set<Circle> circles = Set.from([
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
      // Set<Marker> markerList = {
      //   Marker(
      //     markerId: MarkerId('current_Postion'),
      //     infoWindow: InfoWindow(title: 'Current Position'),
      //     position: LatLng(position.latitude, position.longitude),
      //     icon: BitmapDescriptor.defaultMarkerWithHue(
      //       BitmapDescriptor.hueGreen,
      //     ),
      //   )
      // };
      emit(MapLoadSuccess(
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
