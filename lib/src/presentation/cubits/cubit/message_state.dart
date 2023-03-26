part of 'message_cubit.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {
  MessageInitial();

  @override
  List<Object> get props => [];
}

class LoadingState extends MessageState {
  @override
  List<Object> get props => [];
}

class LoadingNewMessageState extends MessageState {
  @override
  List<Object> get props => [];
}

class LoadedState extends MessageState {
  LoadedState();
  @override
  List<Object> get props => [];
}

class ErrorState extends MessageState {
  ErrorState();
  @override
  List<Object> get props => [];
}
