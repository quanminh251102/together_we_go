import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../cubits/map/map/map_cubit.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class AnnotationClickListener extends OnCircleAnnotationClickListener {
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
  MapboxMap? mapboxMap;
  var isLight = true;
  bool showOrnaments = true;
  OrnamentPosition compassPosition = OrnamentPosition.TOP_RIGHT;
  bool showScaleBar = true;
  OrnamentPosition scaleBarPosition = OrnamentPosition.TOP_LEFT;
  OrnamentPosition logoPosition = OrnamentPosition.BOTTOM_LEFT;
  OrnamentPosition attributionPosition = OrnamentPosition.BOTTOM_LEFT;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createCircleAnnotationManager().then((value) async {
      circleAnnotationManager = value;
      circleAnnotationManager!
          .create(CircleAnnotationOptions(
            geometry: Point(
                    coordinates:
                        BlocProvider.of<MapCubit>(context).userLocation)
                .toJson(),
            circleSortKey: 1.0,
            circleBlur: 0.2,
            circleColor: Colors.blue.shade100.withOpacity(0.5).value,
            circleRadius: 200.0,
            circleStrokeColor: Colors.blue.shade100.withOpacity(0.1).value,
            circleStrokeOpacity: 1.0,
            circleStrokeWidth: 1.0,
          ))
          .then((value) => circleAnnotation = value);
    });
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes = await rootBundle.load('assets/images/pin.png');
      final Uint8List list = bytes.buffer.asUint8List();
      pointAnnotationManager!
          .create(PointAnnotationOptions(
              geometry: Point(
                      coordinates:
                          BlocProvider.of<MapCubit>(context).userLocation)
                  .toJson(),
              textOffset: [0.0, -2.0],
              textColor: Colors.black.value,
              symbolSortKey: 10,
              image: list))
          .then((value) => pointAnnotation = value);
    });
    mapboxMap.compass.updateSettings(CompassSettings(
      position: compassPosition,
      enabled: showOrnaments,
      marginBottom: 10,
      marginLeft: 10,
      marginTop: 10,
      marginRight: 10,
    ));

    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(
      position: scaleBarPosition,
      enabled: showScaleBar,
      marginBottom: 20,
      marginLeft: 20,
      marginTop: 20,
      marginRight: 20,
    ));

    mapboxMap.logo.updateSettings(LogoSettings(
      position: logoPosition,
      marginBottom: 30,
      marginLeft: 30,
      marginTop: 30,
      marginRight: 30,
    ));

    mapboxMap.attribution
        .updateSettings(AttributionSettings(position: attributionPosition));
    mapboxMap.subscribe(_eventObserver, [
      MapEvents.STYLE_LOADED,
      MapEvents.MAP_LOADED,
      MapEvents.MAP_IDLE,
    ]);
  }

  _eventObserver(Event event) {
    print("Receive event, type: ${event.type}, data: ${event.data}");
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), begin: ${data.begin}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    print("MapIdleEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    print("MapLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    print("MapLoadingErrorEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    print(
        "RenderFrameStartedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    print(
        "RenderFrameFinishedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    print("SourceAddedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    print("SourceDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    print("SourceRemovedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    print("StyleDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    print("StyleImageMissingEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    print("StyleImageUnusedEventData: begin: ${data.begin}, end: ${data.end}");
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
                    onMapCreated: _onMapCreated,
                    onStyleLoadedListener: _onStyleLoadedCallback,
                    onCameraChangeListener: _onCameraChangeListener,
                    onMapIdleListener: _onMapIdleListener,
                    onMapLoadedListener: _onMapLoadedListener,
                    onMapLoadErrorListener: _onMapLoadingErrorListener,
                    onRenderFrameStartedListener: _onRenderFrameStartedListener,
                    onRenderFrameFinishedListener:
                        _onRenderFrameFinishedListener,
                    onSourceAddedListener: _onSourceAddedListener,
                    onSourceDataLoadedListener: _onSourceDataLoadedListener,
                    onSourceRemovedListener: _onSourceRemovedListener,
                    onStyleDataLoadedListener: _onStyleDataLoadedListener,
                    onStyleImageMissingListener: _onStyleImageMissingListener,
                    onStyleImageUnusedListener: _onStyleImageUnusedListener,
                    styleUri: MapboxStyles.MAPBOX_STREETS,
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
