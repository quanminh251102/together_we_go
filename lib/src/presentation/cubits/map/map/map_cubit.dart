import 'dart:convert' as convert;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import '../../../../config/url/config.dart';
import '../../../../utils/constants/colors.dart';
import '../../../models/booking.dart';
import '../../../views/map_page/widget/bottom_sheet.dart';
part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());
  List<Marker> listMarker = [];
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
          for (var book in bookingAvailable) {
            userLocation = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
            listMarker.add(Marker(
              point: latlong2.LatLng(
                  userLocation.latitude, userLocation.longitude),
              builder: (context) {
                return const UserMarker();
              },
            ));
            listMarker.add(Marker(
                point: latlong2.LatLng(double.parse(book.startPointLat),
                    double.parse(book.startPointLong)),
                builder: (context) {
                  return IconButton(
                      onPressed: () {
                        listMarker.removeAt(0);
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
                        listMarker.add(Marker(
                          point: latlong2.LatLng(double.parse(book.endPointLat),
                              double.parse(book.endPointLong)),
                          builder: (context) {
                            return const Icon(Icons.location_pin);
                          },
                        ));
                        emit(MapShowDetail(
                            coordinates: coordinates,
                            bounds: bounds,
                            listMarkers: listMarker,
                            book: book));
                      },
                      icon: const Icon(Icons.book));
                }));
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
        for (var book in bookingAvailable) {
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
          listMarker.add(Marker(
              point: latlong2.LatLng(double.parse(book.startPointLat),
                  double.parse(book.startPointLong)),
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      listMarker.removeAt(0);
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
                      listMarker.add(Marker(
                        point: latlong2.LatLng(double.parse(book.endPointLat),
                            double.parse(book.endPointLong)),
                        builder: (context) {
                          return const Icon(Icons.location_pin);
                        },
                      ));
                      emit(MapShowDetail(
                          coordinates: coordinates,
                          bounds: bounds,
                          listMarkers: listMarker,
                          book: book));
                    },
                    icon: const Icon(Icons.book));
              }));
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
    listMarker.clear();
    await requestLocationPermission();
  }
}

class UserMarker extends StatefulWidget {
  const UserMarker({Key? key}) : super(key: key);

  @override
  State<UserMarker> createState() => _UserMarkerState();
}

class _UserMarkerState extends State<UserMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    sizeAnimation = Tween<double>(
      begin: 45,
      end: 60,
    ).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));
    animationController.repeat(
      reverse: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: sizeAnimation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: child,
          ),
        );
      },
      child: const Icon(
        Icons.person_pin,
        color: Colors.black,
        size: 35,
      ),
    );
  }
}
