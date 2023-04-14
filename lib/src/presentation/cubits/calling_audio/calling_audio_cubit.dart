import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../app_socket.dart';

part 'calling_audio_state.dart';

class CallingAudioCubit extends Cubit<CallingAudioState> {
  CallingAudioCubit() : super(CallingAudioInitial());
  bool init_socket = false;

  void init_socket_calling_audio() {
    if (this.init_socket == false) {
      print('init_socket_calling_audio');
      appSocket.socket.on('calling', (jsonData) {
        print('calling audio');
      });
      appSocket.socket.on("get_calling", (value) {
        print('get_calling');
      });
      this.init_socket = true;
    }
  }

  void make_call(String parnerId) {
    Map data = {
      'partner_id': '${parnerId}',
    };
    appSocket.socket.emit('calling', data);
  }
}
