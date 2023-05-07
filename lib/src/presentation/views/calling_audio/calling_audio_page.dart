import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../utils/constants/colors.dart';
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
        context.read<CallingAudioCubit>().call_type == 'video'
            ? 'Bạn đang thực hiện cuộc gọi video...'
            : 'Bạn đang thực hiện cuộc gọi thường...',
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
        context.read<CallingAudioCubit>().call_type == 'video'
            ? 'Đang gọi video đến bạn...'
            : 'Đang gọi thường đến bạn...',
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

    Widget meeting_body_video = Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.blueGrey[900],
                ),
                // SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height,
                // ),
                Positioned(
                  //top: (MediaQuery.of(context).size.height - 200) / 2,
                  //left: (MediaQuery.of(context).size.width - 300) / 2,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: MediaQuery.of(context).size.height,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(color: Colors.black54),
                    child: RTCVideoView(
                      context.watch<CallingAudioCubit>().remoteRenderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      mirror: true,
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 24,
                  child: Container(
                    width: 50,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(232, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(
                              100.0) //                 <--- border radius here
                          ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // (context.watch<CallingAudioCubit>().isCaller == true)
                        //     ? CustomCard(
                        //         width: 40,
                        //         height: 40,
                        //         borderRadius: 36,
                        //         onTap: () {
                        //           socketProvider.makeCall(socketProvider
                        //               .MeetingScreen_peerId as String);
                        //         },
                        //         child: Icon(
                        //           Icons.refresh,
                        //           color: Colors.grey,
                        //         ),
                        //       )
                        //     : SizedBox(),
                        CustomCard(
                            width: 40,
                            height: 40,
                            borderRadius: 36,
                            // childPadding: 12,
                            color: Colors.white,
                            onTap: () {
                              BlocProvider.of<CallingAudioCubit>(context)
                                  .toggleCamera();
                            },
                            child: Center(
                              child: Icon(
                                Icons.switch_camera,
                                color: Colors.grey,
                                size: 29,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 24,
                  top: 64,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    width: 110,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3.0),
                      borderRadius: BorderRadius.all(Radius.circular(
                              11.0) //                 <--- border radius here
                          ),
                    ),
                    child: RTCVideoView(
                        context.watch<CallingAudioCubit>().localRenderer,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        mirror: true),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: (MediaQuery.of(context).size.width - 350.0) / 2,
                  child: Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(232, 255, 255, 255),
                      borderRadius: BorderRadius.all(Radius.circular(
                              25.0) //                 <--- border radius here
                          ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 12),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              CustomCard(
                                  width: 56,
                                  height: 56,
                                  borderRadius: 36,
                                  color: Colors.white,
                                  childPadding: 16,
                                  onTap: () {
                                    BlocProvider.of<CallingAudioCubit>(context)
                                        .set_isAudio();
                                    BlocProvider.of<CallingAudioCubit>(context)
                                        .toggleAudio();
                                  },
                                  child:
                                      context.watch<CallingAudioCubit>().isAudio
                                          ? Icon(
                                              Icons.mic,
                                              color: Colors.black,
                                            )
                                          : Icon(
                                              Icons.mic_off,
                                              color: Colors.black,
                                            )),
                              SizedBox(width: 8),
                              CustomCard(
                                width: 56,
                                height: 56,
                                borderRadius: 36,
                                childPadding: 16,
                                color: Colors.white,
                                onTap: () {
                                  BlocProvider.of<CallingAudioCubit>(context)
                                    ..set_isVideo();
                                  BlocProvider.of<CallingAudioCubit>(context)
                                      .toggleVideo();
                                  // socketProvider.send_server_cam_click();
                                },
                                child:
                                    context.watch<CallingAudioCubit>().isVideo
                                        ? Icon(
                                            Icons.video_call,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.videocam_off,
                                            color: Colors.black,
                                          ),
                              ),
                              SizedBox(width: 8),
                              CustomCard(
                                width: 110,
                                height: 56,
                                borderRadius: 36,
                                childPadding: 16,
                                color: AppColors.primaryColor,
                                onTap: () {
                                  BlocProvider.of<CallingAudioCubit>(context)
                                      .stop_call();
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Kết thúc',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ]),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

              if (state == 'calling_audio' &&
                  context.read<CallingAudioCubit>().call_type == 'video')
                return meeting_body_video;

              return pageBody(state);
            }
            return SizedBox();
          }),
    );
  }
}
