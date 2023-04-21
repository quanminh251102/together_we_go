import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../../config/url/config.dart';
import '../../../models/booking.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());
  void getListBooking() async {
    try {
      emit(BookingLoading());
      var result = await http.get(
        Uri.parse(urlGetListBooking),
      );
      if (result.statusCode == 200) {
        print(jsonDecode(result.body));
        List<dynamic> data = jsonDecode(result.body) as List<dynamic>;
        List<Booking> bookingAvailable = [];
        List<Booking> bookingComplete = [];
        List<Booking> bookingCancel = [];
        for (int i = 0; i < data.length; i++) {
          if (data[i]['status'] == 'available') {
            bookingAvailable.add(Booking.toBooking(data[i]));
          } else {
            if (data[i]['status'] == 'complete') {
              bookingComplete.add(Booking.toBooking(data[i]));
            } else {
              bookingCancel.add(Booking.toBooking(data[i]));
            }
          }
        }
        emit(BookingLoaded(
            listAvailable: bookingAvailable,
            listComplete: bookingComplete,
            listCancel: bookingCancel));
      }
    } catch (e) {
      print(e);
      emit(BookingError());
    }
  }
}
