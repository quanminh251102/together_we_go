part of 'calling_audio_cubit.dart';

abstract class CallingAudioState extends Equatable {
  const CallingAudioState();

  @override
  List<Object> get props => [];
}

class CallingAudioInitial extends CallingAudioState {}

class CallingAudioNewState extends CallingAudioState {
  CallingAudioNewState();
  @override
  List<Object> get props => [];
}

class CallingAudioLoadedState extends CallingAudioState {
  CallingAudioLoadedState();
  @override
  List<Object> get props => [];
}
