import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../services/message.dart';
import '../app_socket.dart';
import '../../models/message.dart';
import 'package:flutter/material.dart';
part 'message_state.dart';

final String chatRoomId = "641dc278b35f299b2b12b2ea";

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial()) {
    get_message();
  }
  String curent_user_id = "";
  ScrollController controller = new ScrollController();
  List<Message> messages = [];
  bool init_socket_message = false;

  void scrollDown() {
    if (controller.hasClients) {
      controller.jumpTo(controller.position.maxScrollExtent + 100);
    }
  }

  void set_user_id(String user_id) {
    curent_user_id = user_id;
  }

  String get_user_id() {
    return curent_user_id;
  }

  void init_socket() {
    if (init_socket_message == false) {
      appSocket.socket.on('receive_message_from_chat_room', (jsonData) {
        final currentState = state;
        if (currentState is LoadedState) {
          final new_t = json.encode(jsonData);
          final data = json.decode(new_t) as Map<String, dynamic>;
          Message _message = Message.fromJson(data);

          this.messages.add(_message);

          print("debug : received message");
          emit(LoadingNewMessageState());
          emit(LoadedState());
          scrollDown();
        }
      });
      init_socket_message = true;
    }
    join_chat_room();
  }

  void join_chat_room() {
    Map data = {
      'chat_room_id': '$chatRoomId',
    };
    appSocket.socket.emit('join_chat_room', data);
  }

  void send_message_to_chat_room(
    String message,
    String type,
  ) {
    Message _message = Message(
      chatRoomId: chatRoomId,
      userId: curent_user_id,
      message: message,
      type: type,
    );
    this.messages.add(_message);

    Map data = {
      'chat_room_id': chatRoomId,
      'userId': curent_user_id,
      'message': message,
      'type': type,
    };
    appSocket.socket.emit('send_message_to_chat_room', data);
    emit(LoadingNewMessageState());
    emit(LoadedState());
    scrollDown();
  }

  void leave_chat_room() {
    Map data = {
      'chat_room_id': '$chatRoomId',
    };
    appSocket.socket.emit('leave_chat_room', data);
  }

  void get_message() async {
    try {
      emit(LoadingState());
      this.messages = await MessageService.getMessageChatRoom(chatRoomId);

      var customMessages = [];
      for (int i = 0; i < this.messages.length; i++) {
        var message = this.messages[i];
        if (i == 0) {
          var newMessage = message;
          newMessage.message = (message.createdAt as String).substring(0, 10);
          newMessage.type = "isDate";
          customMessages.add(newMessage);
        } else {
          var oldMessageDate =
              (this.messages[i - 1].createdAt as String).substring(0, 10);
          var meesageDate = (message.createdAt as String).substring(0, 10);
          if (oldMessageDate != meesageDate) {
            var newMessage = message;
            newMessage.message = (message.createdAt as String).substring(0, 10);
            newMessage.type = "isDate";
            customMessages.add(newMessage);
          }
        }
        customMessages.add(message);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients) {
          controller.jumpTo(controller.position.maxScrollExtent);
        }
      });
      emit(LoadedState());
      scrollDown();
    } catch (e) {
      print(e);
      emit(ErrorState());
    }
  }
}
