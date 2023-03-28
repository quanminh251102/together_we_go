import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/colors.dart';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Inbox'), Icon(Icons.message)],
          ),
          Container(
            height: 400,
            child: BlocConsumer<ChatRoomsCubit, ChatRoomsState>(
              listener: (context, state) {},
              builder: (BuildContext context, state) {
                if (state is LoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ErrorState) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.close),
                        Text('Error: Loading Chat Room failed'),
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
                          elevation: 0,
                          height: 80,
                          childPadding: 8,
                          onTap: () {
                            BlocProvider.of<Message.MessageCubit>(context)
                                .setChatRoom(chatRoom);
                            BlocProvider.of<Message.MessageCubit>(context)
                                .get_message();
                            BlocProvider.of<Message.MessageCubit>(context)
                                .join_chat_room();
                            appRouter.push(const ChatPageRoute());
                          },
                          borderRadius: 12,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage(chatRoom.partner_avatar),
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(width: 12),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      chatRoom.partner_name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text('............')
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomCard(
                                    width: 26,
                                    height: 26,
                                    child: Center(
                                      child: Text(
                                        '1',
                                      ),
                                    ),
                                    color: AppColors.primaryColor,
                                    borderRadius: 12,
                                  ),
                                  Text('01:30')
                                ],
                              ),
                            ],
                          ),
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
