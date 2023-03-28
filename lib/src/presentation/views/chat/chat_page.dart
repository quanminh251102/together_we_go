import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../utils/constants/colors.dart';
import '../../cubits/app_user.dart';
import '../../cubits/chat/message_cubit.dart';
import '../../models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

import '../../services/image.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _controller = TextEditingController();
  ScrollController controller = new ScrollController();
  ItemScrollController itemScrollController = new ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  late bool isFirstTimeNavigateToPage = true;
  late bool isTop = true;
  late bool isNotTop = false;
  late bool isLoading = false;
  List<int> indexOnViews = [];
  bool _isLoading = false;
  int numLoad = 1;
  List<Message> list = [];
  //late IO.Socket socket;

  bool stateIsKeyBoardShow = false;

  bool _isLoadingImage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MessageCubit>().get_message();
  }

  void uploadImage(XFile file) {
    setState(() {
      _isLoadingImage = true;
    });

    ImageService.uploadFile(file).then((value) {
      if (value != "error") {
        context
            .read<MessageCubit>()
            .send_message_to_chat_room(value, "isImage");
      }
      setState(() {
        _isLoadingImage = false;
      });
    });
  }

  void openMediaDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Chọn nguồn',
              style: TextStyle(fontSize: 14),
            ),
            content: Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        print("get successfully");
                        uploadImage(image as XFile);
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                        Text('Máy ảnh')
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  InkWell(
                    onTap: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        uploadImage(image as XFile);
                        Future.delayed(Duration.zero, () {
                          Navigator.pop(context);
                        });
                        // image.path
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image,
                          size: 30,
                        ),
                        Text('Thư viện')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // void make_call(String callType) {
  //   SocketProvider.userId1_in_current_room = widget.chatRoom.UserId1;
  //   SocketProvider.userId2_in_current_room = widget.chatRoom.UserId2;

  //   String correct_id = '';

  //   if (SocketProvider.current_user_id ==
  //       SocketProvider.userId1_in_current_room) {
  //     correct_id = SocketProvider.userId2_in_current_room as String;
  //   } else {
  //     correct_id = SocketProvider.userId1_in_current_room as String;
  //   }
  //   SocketProvider.isCaller = true;

  //   Map data = {
  //     'receiver_id': '${correct_id}',
  //     'call_type': callType,
  //   };
  //   socket.emit("make_call", data);
  // }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = 80.0;
    final botttomNavigatebarHeight = 80.0;
    final bodyHeight = MediaQuery.of(context).size.height -
        appBarHeight -
        botttomNavigatebarHeight;

    final isKeyBoardShow = MediaQuery.of(context).viewInsets.bottom > 0;
    final keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;
    final current_user_id = appUser.id;
    final _appBar = AppBar(
      toolbarHeight: appBarHeight,
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        onPressed: () {
          BlocProvider.of<MessageCubit>(context).leave_chat_room();
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                context.read<MessageCubit>().chatRoom.partner_avatar),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // HandleString.validateForLongStringWithLim(
                //   (SocketProvider.current_user_id == widget.chatRoom.UserId1
                //       ? widget.chatRoom.UserName2
                //       : widget.chatRoom.UserName1),
                //   10,
                // ),
                context.read<MessageCubit>().chatRoom.partner_name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  color: Color(0xFF7C7C7C),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            //make_call('just_audio');
          },
          icon: const Icon(
            Icons.call,
          ),
        ),
        IconButton(
          onPressed: () {
            //make_call('meeting');
          },
          icon: const Icon(
            Icons.video_call_sharp,
          ),
        ),
      ],
    );

    Widget textRight(Message message, String startTime) => Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: Text(
                      message.message,
                      style: const TextStyle(
                          color: AppColors.textPrimaryColor, fontSize: 15),
                    ),
                  ),
                  Text(
                    startTime,
                    style: TextStyle(color: AppColors.textSecondaryColor),
                  )
                ],
              ),
            ),
          ),
        );

    Widget textLeft(Message message, String startTime) => Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    context.read<MessageCubit>().chatRoom.partner_avatar),
              ),
              const SizedBox(width: 10),
              Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color.fromARGB(94, 158, 158, 158),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 180),
                      child: Text(
                        message.message,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      startTime,
                      style: TextStyle(color: AppColors.textSecondaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        );

    Widget imageRight(Message message, String startTime) => Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(message.message,
                        width: 150, fit: BoxFit.fill)),
                SizedBox(height: 4),
                Text(startTime,
                    style: TextStyle(color: AppColors.textSecondaryColor)),
              ],
            ),
          ),
        );

    Widget imageLeft(Message message, String startTime) => Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    context.read<MessageCubit>().chatRoom.partner_avatar),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(message.message,
                          width: 150, fit: BoxFit.fill)),
                  SizedBox(height: 4),
                  Text(
                    startTime,
                    style: TextStyle(color: AppColors.textSecondaryColor),
                  )
                ],
              ),
            ],
          ),
        );
    context.watch<MessageCubit>().scrollDown();

    Widget dateWidget(Message message, String startTime) => Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
        child: Center(
            child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.fromARGB(97, 158, 158, 158),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.message,
            style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 12),
          ),
        )));
    final _message_list = BlocConsumer<MessageCubit, MessageState>(
      listener: (BuildContext context, state) async {
        // if (state is FetchingCompletedState) {
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //       content: Text("Güncellendi, Kayıt S: ${state.recordCount}")));
        // }
        // if (state is FetchingErrorState) {
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text("Tekrar deneniyor")));
        //   await Future.delayed(Duration(seconds: 2));
        //   context.read<InfiniteScrollCubit>().startFetching();
        // }
        if (state is LoadedState) {
          context.read<MessageCubit>().scrollDown();
          setState(() {});
          print('hi');
        }
      },
      builder: (BuildContext context, state) {
        context.read<MessageCubit>().scrollDown();
        if (state is LoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ErrorState) {
          return Center(
            child: Column(
              children: [
                Icon(Icons.close),
              ],
            ),
          );
        } else if (state is LoadedState) {
          var messages = context.read<MessageCubit>().messages;

          if (messages.length == 0) {
            return const Center(
                child: Text("Hiện tại chưa có tin nhắn",
                    style: TextStyle(
                      fontSize: 20,
                    )));
          }

          final messagesList = ListView.builder(
              controller: context.watch<MessageCubit>().controller,
              itemCount: context.watch<MessageCubit>().messages.length,
              itemBuilder: (context, index) {
                var _message = messages[index];
                String customStartTime =
                    DateTime.parse(_message.createdAt as String)
                        .toLocal()
                        .toString()
                        .substring(11, 16);

                String _type = _message.type;

                return (_type == "isDate")
                    ? dateWidget(_message, customStartTime)
                    : _message.userId == current_user_id // mean is Me
                        ? ((_type == "isText")
                            ? (textRight(_message, customStartTime))
                            : (imageRight(_message, customStartTime)))
                        : ((_type == "isText")
                            ? (textLeft(_message, customStartTime))
                            : (imageLeft(_message, customStartTime)));
              });
          return messagesList;
        } else {
          return Container();
        }
      },
    );
    final _body = SingleChildScrollView(
      child: Column(
        children: [
          Visibility(
            visible: isLoading,
            child: CupertinoActivityIndicator(),
          ),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SizedBox(
              height: (bodyHeight - 50 - keyBoardHeight) +
                  ((_isLoadingImage) ? -100 : 0),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                ),
                child: _message_list,
              ),
            ),
          ),
          //SizedBox(height: botttomNavigatebarHeight),
          Visibility(
            visible: _isLoadingImage,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
        ],
      ),
    );

    final _bottomNavigationBar = SizedBox(
      height: botttomNavigatebarHeight,
      child: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE8EAF3),
            ),
          ),
        ),
        child: Row(
          children: [
            // Container(
            //   width: 100,
            //   decoration: BoxDecoration(
            //       color: const Color(0xFFE8FDF2),
            //       borderRadius: BorderRadius.circular(8)),
            //   padding: const EdgeInsets.all(12),
            //   child: const Text(
            //     'Bắt đầu tư vấn',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       color: Color(0xFF0E9D57),
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Viết tin nhắn',
                  suffixIcon: InkWell(
                      onTap: () {
                        print("upload image");
                        openMediaDialog();
                      },
                      child: Icon(
                        Icons.image,
                        color: AppColors.primaryColor,
                      )),
                ),
              ),
            ),
            IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.send,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                BlocProvider.of<MessageCubit>(context)
                    .send_message_to_chat_room(
                  _controller.text.trim(),
                  "isText",
                );

                _controller.text = "";
                // if (list.length > 0) {
                //   itemScrollController.jumpTo(index: list.length);
                // }
              },
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Scaffold(
        appBar: _appBar,
        body: _body,
        bottomNavigationBar: _bottomNavigationBar,
      ),
    );
  }
}
