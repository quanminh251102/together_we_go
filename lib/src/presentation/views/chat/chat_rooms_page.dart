import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../../config/router/app_router.dart';
import '../../../service/notifi_service.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/funtions/long_string.functions.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: [
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
                            Text('Error: Loading Chat Room failed'),
                          ],
                        ),
                      );
                    } else if (state is LoadedState) {
                      final chatRooms = ListView.builder(
                          itemCount:
                              context.watch<ChatRoomsCubit>().chat_rooms.length,
                          itemBuilder: (context, index) {
                            var chatRoom = context
                                .watch<ChatRoomsCubit>()
                                .chat_rooms[index];

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
                                  CachedNetworkImage(
                                    imageUrl: chatRoom.partner_avatar,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                60.0) //                 <--- border radius here
                                            ),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  SizedBox(width: 12),
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          handleLongString(
                                              chatRoom.partner_name),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(handleLongString(
                                            chatRoom.lastMessage["message"]))
                                      ],
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (chatRoom.numUnWatch > 0)
                                        CustomCard(
                                          width: 26,
                                          height: 26,
                                          child: Center(
                                            child: Text(
                                              chatRoom.numUnWatch.toString(),
                                            ),
                                          ),
                                          color: AppColors.primaryColor,
                                          borderRadius: 12,
                                        ),
                                      if (chatRoom.numUnWatch == 0)
                                        SizedBox(
                                          width: 26,
                                          height: 26,
                                        ),
                                      Text(handeDateString_getTime(
                                          chatRoom.lastMessage["createdAt"]))
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
        ),
      ),
    );
  }
}
