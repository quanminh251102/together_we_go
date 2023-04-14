import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../config/router/app_router.dart';
import '../../cubits/chat/chat_rooms_cubit.dart';
import '../../cubits/chat/message_cubit.dart' as Message;

class ChatRoomsPage extends StatefulWidget {
  const ChatRoomsPage({super.key});

  @override
  State<ChatRoomsPage> createState() => _ChatRoomsPageState();
}

class _ChatRoomsPageState extends State<ChatRoomsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 64),
          const Text('Message Page'),
          Container(
            height: 400,
            child: BlocConsumer<ChatRoomsCubit, ChatRoomsState>(
              listener: (context, state) {},
              builder: (BuildContext context, state) {
                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ErrorState) {
                  return Center(
                    child: Column(
                      children: [
                        const Icon(Icons.close),
                      ],
                    ),
                  );
                } else if (state is LoadedState) {
                  final chatRooms = ListView.builder(
                      itemCount:
                          context.watch<ChatRoomsCubit>().chat_rooms.length,
                      itemBuilder: (context, index) {
                        var chatRoom =
                            context.watch<ChatRoomsCubit>().chat_rooms[index];

                        return CustomCard(
                          onTap: () {
                            BlocProvider.of<Message.MessageCubit>(context)
                                .setChatRoom(chatRoom);
                            BlocProvider.of<Message.MessageCubit>(context)
                                .get_message();
                            BlocProvider.of<Message.MessageCubit>(context)
                                .join_chat_room();
                            appRouter.push(const ChatPageRoute());
                          },
                          child: Text(chatRoom.partner_name),
                        );
                      });
                  return chatRooms;
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
