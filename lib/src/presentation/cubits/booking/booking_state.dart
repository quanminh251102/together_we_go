// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> listAvailable;
  final List<Booking> listComplete;
  final List<Booking> listCancel;
  BookingLoaded({
    required this.listAvailable,
    required this.listComplete,
    required this.listCancel,
  });
}

class BookingError extends BookingState {}
