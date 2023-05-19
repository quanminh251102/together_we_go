import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../../../../config/url/config.dart';
import '../../../../models/address.dart';
import '../../../../models/distance.dart';
import '../../../../models/place_search.dart';
import '../../../app_user.dart';

part 'search_map_state.dart';

class SearchMapCubit extends Cubit<SearchMapState> {
  SearchMapCubit() : super(SearchMapInitial());
  List<PlaceSearch> placeSearchList = [];
  PlaceSearch startPlace = new PlaceSearch(
      description: '', mainText: '', placeId: '', secondaryText: '');
  PlaceSearch endPlace = new PlaceSearch(
      description: '', mainText: '', placeId: '', secondaryText: '');
  Future<void> getSearchPlace(String search) async {
    if (search.isEmpty) {
      emit(SearchMapInitial());
    } else {
      emit(SearchMapLoading());
      var url =
          'https://rsapi.goong.io/Place/AutoComplete?api_key=FazAEl6Rima3SEVquUL7wib3FYu4sbS8gc94c2I2&input=$search';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('do');
        var json = convert.jsonDecode(response.body);
        var jsonResults = json['predictions'] as List;
        placeSearchList =
            jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();

        emit(SearchMaping(placeSearchList: placeSearchList));
      } else {
        print('loi');
        emit(SearchMapError());
      }
    }
  }

  void doneStartSearch(PlaceSearch placeSearch) {
    startPlace = placeSearch;
    emit(SearchMapInitial());
  }

  void doneEndSearch(PlaceSearch placeSearch) {
    endPlace = placeSearch;
    emit(SearchMapInitial());
  }

  Future<DistanceMatrix> getDistance(
      LatLng startLocation, LatLng endLocation) async {
    var distanceURL =
        'https://rsapi.goong.io/DistanceMatrix?origins=${startLocation.latitude},${startLocation.longitude}&destinations=${endLocation.latitude},${endLocation.longitude}&vehicle=hd&api_key=FazAEl6Rima3SEVquUL7wib3FYu4sbS8gc94c2I2';
    var response = await http.get(Uri.parse(distanceURL));
    if (response.statusCode == 200) {
      var json = convert.jsonDecode(response.body);
      var jsonResults = json['rows'][0]['elements'] as List;
      DistanceMatrix distanceMatrix = DistanceMatrix.fromJson(jsonResults[0]);
      return distanceMatrix;
    } else {
      DistanceMatrix distanceMatrix = DistanceMatrix(km: '0', min: '0');
      return distanceMatrix;
    }
  }

  Future<Location> getLatLng(String placeId) async {
    var url =
        'https://rsapi.goong.io/geocode?place_id=$placeId&api_key=FazAEl6Rima3SEVquUL7wib3FYu4sbS8gc94c2I2';
    var responseLocation = await http.get(Uri.parse(url));
    if (responseLocation.statusCode == 200) {
      var json = convert.jsonDecode(responseLocation.body);
      var jsonResults = json['results'] as List;
      Location location = Location.fromJson(jsonResults[0]);
      return location;
    } else {
      return Location(latitude: '', longitude: '');
    }
  }

  Future<void> addNewBooking(
      String time, String bookingType, String price, String content) async {
    print('addNewBooking');
    Location startLocation = await getLatLng(startPlace.placeId);
    Location endLocation = await getLatLng(endPlace.placeId);
    LatLng start = LatLng(double.parse(startLocation.latitude),
        double.parse(startLocation.longitude));
    LatLng end = LatLng(double.parse(endLocation.latitude),
        double.parse(endLocation.longitude));
    DistanceMatrix distanceMatrix = await getDistance(start, end);
    print('$urlAddNewBooking/${appUser.id}');
    var _content = '';
    if (content == '')
      _content = ' ';
    else
      _content = content;

    var response =
        await http.post(Uri.parse('$urlAddNewBooking/${appUser.id}'), body: {
      'price': price,
      'bookingType': bookingType,
      'time': time,
      'status': 'available',
      'content': content,
      'startPointId': startPlace.placeId,
      'startPointMainText': startPlace.mainText,
      'startPointAddress': startPlace.secondaryText,
      'endPointId': endPlace.placeId,
      'endPointMainText': endPlace.mainText,
      'endPointAddress': endPlace.secondaryText,
      'duration': distanceMatrix.min,
      'distance': distanceMatrix.km,
    });
    if (response.statusCode == 200) {
      print('Đăng bài thành công');
    }
  }
}
