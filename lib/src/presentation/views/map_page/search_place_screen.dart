import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../cubits/map/map/map_cubit.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  MapboxMapController? mapController;

  _onMapCreated(MapboxMapController controller) async {
    mapController = controller;
  }

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
              content: Text('Lỗi khi load'),
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
              body: Stack(
                children: [
                  MapboxMap(
                    styleString:
                        'mapbox://styles/minhquan2511/clhdbvj61014m01pgbkwc0fom',
                    accessToken:
                        'pk.eyJ1IjoibWluaHF1YW4yNTExIiwiYSI6ImNsZ3oyc2ZxbzBmYWozanFxbG1pODc1bGoifQ.j_kPZgz3hnzfwTALnZNYBA',
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    trackCameraPosition: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        state.position.latitude,
                        state.position.longitude,
                      ),
                      zoom: 11.0,
                    ),
                    onMapClick: (_, latlng) async {
                      await mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 10.0,
                            target: LatLng(latlng.latitude, latlng.longitude),
                            tilt: 30.0,
                            zoom: 12.0,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Hi there!',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              const Text('You are currently here:'),
                              Text(
                                  'Longitude: ${state.position.longitude} - Latitude: ${state.position.latitude}',
                                  style: const TextStyle(color: Colors.indigo)),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
}
