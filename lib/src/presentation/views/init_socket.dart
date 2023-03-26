import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/router/app_router.dart';
import '../cubits/app_socket.dart';
import '../cubits/cubit/message_cubit.dart';

class InitSocket extends StatefulWidget {
  const InitSocket({super.key});

  @override
  State<InitSocket> createState() => _InitSocketState();
}

class _InitSocketState extends State<InitSocket> {
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('init socket with user id')),
      body: Column(children: [
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<MessageCubit>(context)
                .set_user_id('641dbea9d1f2c25f2151b2d7');
            print('user 1');
          },
          child: Text('USER 1'),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<MessageCubit>(context)
                .set_user_id('641dbebcd1f2c25f2151b2da');
            print('user 2');
          },
          child: Text('USER 2'),
        ),
        ElevatedButton(
          onPressed: () {
            appSocket.init();
            BlocProvider.of<MessageCubit>(context).init_socket();
            appRouter.push(const ChatPageRoute());
          },
          child: Text('login'),
        ),
      ]),
    );
  }
}
