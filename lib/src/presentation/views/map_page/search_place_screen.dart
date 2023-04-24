import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cubits/booking/booking_cubit.dart';
import '../../cubits/map/map_cubit.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

const kGoogleApiKey = 'AIzaSyCZXr0NOKXIcaZFmfzelhXk1NurDc7uUig';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  Set<Marker> markerList = {};
  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<MapCubit>(context).requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listener: (context, state) {
        if (state is MapLoadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error in Loading Map'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is MapLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (state is MapLoadSuccess) {
            return Scaffold(
              key: homeScaffoldKey,
              appBar: AppBar(
                title: const Text("Google search places"),
              ),
              body: Stack(children: [
                GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: state.cameraPosition,
                    markers: markerList,
                    onMapCreated: (GoogleMapController controller) {
                      googleMapController = controller;
                    }),
                GestureDetector(
                  onTap: _handleSearchButton,
                  child: Container(
                    color: Colors.blue,
                    width: 100,
                    height: 50,
                    child: const Center(
                        child: Text(
                      'Tìm kiếm',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ]),
            );
          } else {
            return const Center(
              child: Text('Map không tồn tại'),
            );
          }
        }
      },
    );
  }

  Future<void> _handleSearchButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'vi',
        strictbounds: false,
        types: [""],
        textDecoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white))),
        components: [Component(Component.country, "vn")]);
    displayPredictions(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse value) {
    print(value.errorMessage);
  }

  void displayPredictions(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());
    PlacesDetailsResponse detailsResponse =
        await places.getDetailsByPlaceId(p.placeId!);

    final lat = detailsResponse.result.geometry!.location.lat;
    final lng = detailsResponse.result.geometry!.location.lng;

    markerList.clear();
    markerList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detailsResponse.result.name)));
    setState(() {});
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14));
  }
}
