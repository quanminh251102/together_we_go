import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/chat_room.dart';
import '../../services/chat_room.dart';
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
}
