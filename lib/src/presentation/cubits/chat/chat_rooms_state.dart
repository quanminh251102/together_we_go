part of 'chat_rooms_cubit.dart';

abstract class ChatRoomsState extends Equatable {
  const ChatRoomsState();

  @override
  List<Object> get props => [];
}

class ChatRoomsInitial extends ChatRoomsState {}

class LoadingState extends ChatRoomsState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ChatRoomsState {
  LoadedState();
  @override
  List<Object> get props => [];
}

class ErrorState extends ChatRoomsState {
  ErrorState();
  @override
  List<Object> get props => [];
}
