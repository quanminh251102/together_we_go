import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

import '../../../config/router/app_router.dart';
import '../../../config/url/config.dart';
import '../../models/booking.dart';
import '../app_user.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  List<dynamic> bookings = [];
  bool isFilter = false;

  void do_filter(String startPoint, String endPoint) {
    isFilter = true;
    emit(BookingLoading());
    List<Booking> bookingAvailable = [];
    List<Booking> bookingComplete = [];
    List<Booking> bookingCancel = [];
    for (int i = 0; i < bookings.length; i++) {
      Booking booking = Booking.toBooking(bookings[i]);

      bool check = true;

      if (booking.startPointAddress.toLowerCase().contains(startPoint) &&
          booking.endPointAddress.toLowerCase().contains(endPoint)) {
        check = true;
      } else {
        check = false;
      }
      print("kiet ${booking.startPointAddress.toLowerCase()} ${startPoint}");
      print("kiet ${booking.endPointAddress.toLowerCase()} ${endPoint}");
      print(check);

      if (check == true) {
        if (bookings[i]['status'] == 'available') {
          bookingAvailable.add(booking);
        } else {
          if (bookings[i]['status'] == 'complete') {
            bookingComplete.add(booking);
          } else {
            bookingCancel.add(booking);
          }
        }
      }
    }

    print(bookingAvailable);
    print(bookingComplete);
    print(bookingCancel);

    emit(BookingLoaded(
        listAvailable: bookingAvailable,
        listComplete: bookingComplete,
        listCancel: bookingCancel));

    appRouter.push(HomePageViewRoute(email: appUser.gmail, index: 1));
  }

  void getListBooking() async {
    if (isFilter == false) {
      print('getListBooking');
      try {
        emit(BookingLoading());
        var result = await http.get(
          Uri.parse(urlGetListBooking),
        );
        if (result.statusCode == 200) {
          print(jsonDecode(result.body));
          List<dynamic> data = jsonDecode(result.body) as List<dynamic>;
          bookings = data;
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
        print('Lỗi');
        print('--------------');
        print('$e');
        emit(BookingError());
      }
    } else {
      isFilter = false;
    }
  }
}
