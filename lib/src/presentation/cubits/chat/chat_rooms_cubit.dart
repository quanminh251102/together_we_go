import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../service/notifi_service.dart';
import '../../models/chat_room.dart';
import '../../services/chat_room.dart';
import '../app_socket.dart';
import '../app_user.dart';

part 'chat_rooms_state.dart';

class ChatRoomsCubit extends Cubit<ChatRoomsState> {
  ChatRoomsCubit() : super(ChatRoomsInitial());

  List<ChatRoom> chat_rooms = [];

  void get_chatRoom() async {
    try {
      emit(LoadingState());
      this.chat_rooms = await ChatRoomService.getChatRoom(appUser.id);
      emit(LoadedState());
    } catch (e) {
      print(e);
      emit(ErrorState());
    }
  }

  void init_socket_chat_room() {
    appSocket.socket.on('reload_chatRooms', (jsonData) {
      get_chatRoom();
      print('reload_chat_rooms');
      NotificationService().showNotification(
          title: 'Thông báo', body: 'Có người nhắn tin với bạn');
    });
  }
}
