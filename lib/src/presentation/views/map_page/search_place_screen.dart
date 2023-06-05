import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:latlong2/latlong.dart' as latlong2;

import '../../../utils/constants/colors.dart';
import '../../cubits/map/map/map_cubit.dart';
import 'widget/bottom_sheet.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  String _message = 'Finding route...';
  var isLight = true;
  bool showOrnaments = true;
  bool showScaleBar = true;

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
              appBar: AppBar(
                title: const Text("Trang chủ"),
              ),
              body: FlutterMap(
                options: MapOptions(
                  // bounds: bounds,
                  boundsOptions: FitBoundsOptions(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 0 + MediaQuery.of(context).padding.top,
                      right: 20,
                    ),
                  ),
                  center: latlong2.LatLng(state.userLocation.latitude,
                      state.userLocation.longitude),
                  zoom: 16,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/minhquan2511/clhf4ua40019201qycb11gxr4/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWluaHF1YW4yNTExIiwiYSI6ImNsaGVpNGNrbTB4ZHozZXA0NWN4NHAydWsifQ.eFaaP1FOzhDovmTSXS6Lsw',
                    userAgentPackageName: 'com.example.app',
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        point: latlong2.LatLng(state.userLocation.latitude,
                            state.userLocation.longitude),
                        radius: 400,
                        useRadiusInMeter: true,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: state.listMarkers,
                  ),
                ],
              ),
            );
          } else if (state is MapShowDetail) {
            return Scaffold(
              body: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      bounds: state.bounds,
                      boundsOptions: FitBoundsOptions(
                        padding: EdgeInsets.only(
                            left: 100,
                            top: 50 + MediaQuery.of(context).padding.top,
                            right: 100,
                            bottom: 300),
                      ),
                      zoom: 8,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/minhquan2511/clhf4ua40019201qycb11gxr4/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWluaHF1YW4yNTExIiwiYSI6ImNsaGVpNGNrbTB4ZHozZXA0NWN4NHAydWsifQ.eFaaP1FOzhDovmTSXS6Lsw',
                        userAgentPackageName: 'com.example.app',
                      ),
                      DirectionsLayer(
                        coordinates: state.coordinates,
                        color: AppColors.primaryColor,
                        strokeWidth: 6,
                      ),
                      MarkerLayer(
                        markers: state.listMarkers,
                      ),
                    ],
                  ),
                  BottomSheetDetail(book: state.book)
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
