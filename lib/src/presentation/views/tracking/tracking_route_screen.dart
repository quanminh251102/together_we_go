// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_directions/flutter_map_directions.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import '../../../config/router/app_router.dart';
import '../apply/apply_in_booking_page.dart';
import '../apply/my_apply_page.dart';
import 'viewmodel/interfaces/itracking_route_viewmodel.dart';

import '../../../utils/constants/colors.dart';

class TrackingScreen extends StatefulWidget {
  final dynamic apply;
  const TrackingScreen({
    Key? key,
    required this.apply,
  }) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late ITrackingRouteViewModel iTrackingRouteViewModel;
  @override
  void initState() {
    iTrackingRouteViewModel = context.read<ITrackingRouteViewModel>();
    Future.delayed(Duration.zero, () async {
      await iTrackingRouteViewModel.init(widget.apply["_id"]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ITrackingRouteViewModel>(
        builder: (context, vm, child) {
          return vm.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        bounds: vm.bounds,
                        boundsOptions: FitBoundsOptions(
                          padding: EdgeInsets.only(
                              left: 100,
                              top: 50 + MediaQuery.of(context).padding.top,
                              right: 100,
                              bottom: 300),
                        ),
                        center: latlong2.LatLng(vm.userLocation.latitude,
                            vm.userLocation.longitude),
                        zoom: 8,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/minhquan2511/clhf4ua40019201qycb11gxr4/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWluaHF1YW4yNTExIiwiYSI6ImNsaGVpNGNrbTB4ZHozZXA0NWN4NHAydWsifQ.eFaaP1FOzhDovmTSXS6Lsw',
                          userAgentPackageName: 'com.example.app',
                        ),
                        DirectionsLayer(
                          coordinates: vm.coordinates,
                          color: AppColors.primaryColor,
                          strokeWidth: 6,
                        ),
                        CurrentLocationLayer(
                          followOnLocationUpdate: FollowOnLocationUpdate.always,
                          style: const LocationMarkerStyle(
                            marker: const DefaultLocationMarker(
                              child: Icon(
                                Icons.navigation,
                                color: Colors.white,
                                size: 10,
                              ),
                            ),
                            markerDirection: MarkerDirection.heading,
                          ),
                        ),
                        MarkerLayer(
                          markers: vm.listMarker,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 10, right: 10),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            appRouter.pop();
                                          },
                                          icon:
                                              const Icon(Icons.close_outlined)),
                                    ],
                                  ),
                                  Text(
                                    '${vm.currentBooking.startPointMainText} - ${vm.currentBooking.endPointMainText}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${vm.currentBooking.time}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(vm
                                                  .currentBooking
                                                  .authorAvatar)),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                vm.currentBooking.authorName,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SvgPicture.asset(
                                                    "assets/svg/distance.svg",
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    vm.currentBooking.distance,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/svg/clock.svg",
                                                    height: 30,
                                                  ),
                                                  Text(
                                                    vm.currentBooking.duration,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${vm.currentBooking.price} VND',
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: GestureDetector(
                                    onTap: () {
                                      print(vm.currentBooking.id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ApplyInBookingPage(
                                            booking: vm.currentBooking.toJson(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: const Center(
                                        child: Text(
                                          'Kết thúc chuyến đi',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )),
                                ]),
                          ),
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
