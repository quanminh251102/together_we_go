import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../cubits/map/map/map_cubit.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap? mapboxMap) {
    this.mapboxMap = mapboxMap;
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
                  MapWidget(
                    key: ValueKey("mapWidget"),
                    resourceOptions: ResourceOptions(
                        accessToken:
                            dotenv.env['MAPBOX_ACCESS_TOKEN'].toString()),
                    cameraOptions: CameraOptions(
                        center: Point(coordinates: state.userLocation).toJson(),
                        zoom: 16.0),
                    onMapCreated: _onMapCreated(state.mapboxMap),
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
                                  'Longitude: ${state.userLocation.lng} - Latitude: ${state.userLocation.lat}',
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
