import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';

import '../../cubits/calling_audio/calling_audio_cubit.dart';

class CallingAudioPage extends StatefulWidget {
  const CallingAudioPage({super.key});

  @override
  State<CallingAudioPage> createState() => _CallingAudioPageState();
}

class _CallingAudioPageState extends State<CallingAudioPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> calling_caller_body = [
      Text(
        'Bạn đang thực hiện cuộc gọi thường...',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
      ),
      SizedBox(height: 100),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            width: 72,
            height: 72,
            borderRadius: 36,
            color: Colors.red,
            onTap: () {
              BlocProvider.of<CallingAudioCubit>(context).stop_call();
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      ),
    ];

    List<Widget> calling_reciver_body = [
      Text(
        'Đang gọi thường đến bạn...',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15),
      ),
      SizedBox(height: 100),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCard(
            width: 72,
            height: 72,
            borderRadius: 36,
            color: Colors.red,
            onTap: () {
              BlocProvider.of<CallingAudioCubit>(context).stop_call();
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(
            width: 72,
          ),
          CustomCard(
            width: 72,
            height: 72,
            borderRadius: 36,
            color: Colors.lightGreenAccent,
            onTap: () {
              BlocProvider.of<CallingAudioCubit>(context).acctepted_calling();
            },
            child: Icon(
              Icons.call,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      )
    ];

    List<Widget> meeting_body_just_auido = [
      BlocConsumer<CallingAudioCubit, CallingAudioState>(
          listener: (BuildContext context, state) async {},
          builder: (BuildContext context, state) {
            if (state is CallingAudioLoadedState) {
              var _start = context.watch<CallingAudioCubit>().start;
              return Text(
                '${(_start ~/ 3600) < 10 ? '0' : ''}${_start ~/ 3600}' +
                    ':${((_start % 3600) ~/ 60) < 10 ? '0' : ''}${(_start % 3600) ~/ 60}' +
                    ':${((_start % 3600) % 60) < 10 ? '0' : ''}${(_start % 3600) % 60}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              );
            }
            return SizedBox();
          }),
      SizedBox(height: 100),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomCard(
            width: 72,
            height: 72,
            borderRadius: 36,
            color: Colors.red,
            onTap: () {
              BlocProvider.of<CallingAudioCubit>(context).stop_call();
            },
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 50,
            ),
          ),
          SizedBox(
            width: 72,
          ),
          CustomCard(
            width: 72,
            height: 72,
            borderRadius: 36,
            color: Colors.white,
            childPadding: 16,
            onTap: () {
              //socketProvider.set_MeetingScreen_isAudio();
              //socketProvider.toggleAudio();
              BlocProvider.of<CallingAudioCubit>(context).toggleAudio();
              BlocProvider.of<CallingAudioCubit>(context).set_isAudio();
              print('toggled audio');
            },
            child: BlocConsumer<CallingAudioCubit, CallingAudioState>(
                listener: (BuildContext context, state) async {},
                builder: (BuildContext context, state) {
                  if (state is CallingAudioLoadedState) {
                    var isAudio = context.watch<CallingAudioCubit>().isAudio;
                    if (isAudio) {
                      return Icon(Icons.mic);
                    }
                    return Icon(Icons.mic_off);
                  }
                  return SizedBox();
                }),
            // child: Icon(Icons.mic),
          ),
        ],
      )
    ];

    pageBody(String name_body) => Scaffold(
          body: Stack(alignment: AlignmentDirectional.topCenter, children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Color.fromARGB(206, 38, 41, 51),
            ),
            Positioned(
              top: 40,
              left: 24,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  BlocProvider.of<CallingAudioCubit>(context).stop_call();
                  // Navigator.of(context).pop();
                },
              ),
            ),
            Positioned(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage:
                          // AssetImage('assets/images/avt_default.gif'),
                          NetworkImage(
                              context.read<CallingAudioCubit>().partner_avatar),
                    ),
                    SizedBox(height: 24),
                    Text(
                      context.read<CallingAudioCubit>().partner_name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 36),
                    ),
                    SizedBox(height: 24),
                    if (name_body == 'calling_audio')
                      ...meeting_body_just_auido,
                    if (name_body == 'calling_caller_body')
                      ...calling_caller_body,
                    if (name_body == 'calling_reciver_body')
                      ...calling_reciver_body,
                  ]),
            ),
          ]),
        );
    Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Thao tác đã được chặn'),
            actions: [
              ElevatedButton(
                child: Text('Đóng'),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        );

    return WillPopScope(
      onWillPop: () async {
        final showPop = await showWarning(context);
        return false;
      },
      child: BlocConsumer<CallingAudioCubit, CallingAudioState>(
          listener: (BuildContext context, state) async {},
          builder: (BuildContext context, state) {
            if (state is CallingAudioLoadedState) {
              var state = context.watch<CallingAudioCubit>().page_state;
              print('kiet debug: ' + state);
              return pageBody(state);
            }
            return SizedBox();
          }),
    );
  }
}