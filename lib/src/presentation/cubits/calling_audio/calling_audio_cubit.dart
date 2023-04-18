import 'dart:async';
import 'dart:convert';

import 'package:audio_session/audio_session.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../config/router/app_router.dart';
import '../../../utils/constants/funtions/audio_player.functions.dart';
import '../../views/calling_audio/calling_audio_page.dart';
import '../app_socket.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:peerdart/peerdart.dart';
part 'calling_audio_state.dart';

class CallingAudioCubit extends Cubit<CallingAudioState> {
  CallingAudioCubit() : super(CallingAudioInitial()) {
    emit(CallingAudioLoadedState());
  }
  bool init_socket = false;
  String partner_id = '';
  String partner_name = '';
  String partner_avatar = '';
  String partner_peer_id = '';
  String page_state = '';

  bool isCaller = true;
  bool inCalling = false;
  bool isTorchOn = false;
  bool isVideo = true;
  bool isAudio = true;
  bool _isLoading_init = false;
  bool _partner_isVideo = true;
  bool inCall = false;
  bool videoEnabled = true;
  bool audioEnabled = true;
  String call_type = '';
  String caller_name = '';
  String status = '';
  String peerId = '';

  MediaStream? localStream;
  MediaRecorder? mediaRecorder;
  List<MediaDeviceInfo>? mediaDevicesList;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  Peer peer = Peer(options: PeerOptions(debug: LogLevel.All));
  MediaConnection? mediaConection;
  MediaStream? _MediaStream;

  Timer? _timer;
  int start = 0;

  void set_isAudio() {
    emit(CallingAudioNewState());
    isAudio = !isAudio;
    emit(CallingAudioLoadedState());
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        emit(CallingAudioNewState());
        start = start + 1;
        emit(CallingAudioLoadedState());
      },
    );
  }

  Future<void> init_peer() async {
    this.isAudio = true;

    peer = Peer(options: PeerOptions(debug: LogLevel.All));
    peer.on("open").listen((id) {
      peerId = peer.id as String;
      print('peer_id: ' + peerId);
      appSocket.socket.emit(
        "init_peer_id",
        {
          "peer_id": peerId,
        },
      );
    });

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      androidAudioAttributes: AndroidAudioAttributes(
        usage: AndroidAudioUsage.voiceCommunicationSignalling,
      ),
    ));

    await localRenderer.initialize();
    await remoteRenderer.initialize();

    final mediaStream = await navigator.mediaDevices
        .getUserMedia({"video": false, "audio": true});

    mediaDevicesList = await navigator.mediaDevices.enumerateDevices();

    this.localStream = mediaStream;

    navigator.mediaDevices.ondevicechange = (event) async {
      //print('++++++ ondevicechange ++++++');
      mediaDevicesList = await navigator.mediaDevices.enumerateDevices();
    };

    peer.on<MediaConnection>("call").listen((call) async {
      emit(CallingAudioNewState());

      call.answer(mediaStream);

      // on peer closed
      call.on("close").listen((event) {
        inCall = false;
      });

      // Get peer stream
      call.on<MediaStream>("stream").listen((event) {
        emit(CallingAudioNewState());
        localRenderer.srcObject = mediaStream;
        remoteRenderer.srcObject = event;
        inCall = true;
        emit(CallingAudioLoadedState());
      });
      emit(CallingAudioLoadedState());
    });
  }

  void init_socket_calling_audio() async {
    if (this.peerId != '') {
      appSocket.socket.emit(
        "init_peer_id",
        {
          "peer_id": peerId,
        },
      );
    }

    await init_peer();

    appSocket.socket.on('calling', (jsonData) {
      print('calling audio');
    });
    appSocket.socket.on("open_calling_ui", (jsonData) async {
      await init_peer();
      print('get_calling');

      final new_t = json.encode(jsonData);
      final data = json.decode(new_t) as Map<String, dynamic>;
      print(data);
      this.start = 0;
      this.isCaller = data['is_caller'];
      this.partner_id = data['partner_id'];
      this.partner_name = data['partner_name'];
      this.partner_avatar = data['partner_avatar'];

      if (this.isCaller == true) {
        this.page_state = 'calling_caller_body';
      } else {
        this.page_state = 'calling_reciver_body';
      }

      audio_play("assets/audios/phone_call.mp3");
      appRouter.push(const CallingAudioPageRoute());
    });

    appSocket.socket.on("acctepted_calling_ui", (jsonData) async {
      final new_t = json.encode(jsonData);
      final data = json.decode(new_t) as Map<String, dynamic>;
      print(data);
      this.partner_peer_id = data["partner_peer_id"];

      emit(CallingAudioNewState());
      startTimer();
      audio_stop();

      page_state = "calling_audio";
      print('calling_audio');

      try {
        if (this.isCaller == true) {
          final mediaStream = await navigator.mediaDevices.getUserMedia({
            "video": false,
            "audio": true,
          });
          mediaDevicesList = await navigator.mediaDevices.enumerateDevices();

          this.localStream = mediaStream;

          var call = peer.call(this.partner_peer_id, mediaStream);

          // Do some stuff with stream
          call.on<MediaStream>("stream").listen((event) {
            emit(CallingAudioNewState());
            remoteRenderer.srcObject = event;
            localRenderer.srcObject = mediaStream;
            inCall = true;
            emit(CallingAudioLoadedState());
          });
        }
      } catch (e) {}
      emit(CallingAudioLoadedState());
    });

    appSocket.socket.on("stop_calling", (jsonData) {
      audio_stop();
      try {
        if (kIsWeb) {
          localStream?.getTracks().forEach((track) => track.stop());
        }
        (_timer as Timer).cancel();
        List<MediaStreamTrack> tracks = localRenderer.srcObject!.getTracks();
        tracks.forEach((track) {
          track.stop();
        });
        tracks = remoteRenderer.srcObject!.getTracks();
        tracks.forEach((track) {
          track.stop();
        });
      } catch (e) {
        print(e);
      }

      appRouter.navigateBack();
    });

    this.init_socket = true;
  }

  void make_call(String partner_id) {
    Map data = {
      'partner_id': '${partner_id}',
    };
    appSocket.socket.emit('calling', data);
  }

  void stop_call() {
    Map data = {
      'partner_id': '${this.partner_id}',
    };
    appSocket.socket.emit('stop_calling', data);
    audio_stop();
    try {
      if (kIsWeb) {
        localStream?.getTracks().forEach((track) => track.stop());
      }
      (_timer as Timer).cancel();
      List<MediaStreamTrack> tracks = localRenderer.srcObject!.getTracks();
      tracks.forEach((track) {
        track.stop();
      });
      tracks = remoteRenderer.srcObject!.getTracks();
      tracks.forEach((track) {
        track.stop();
      });
    } catch (e) {
      print(e);
    }

    appRouter.navigateBack();
  }

  void acctepted_calling() {
    Map data = {
      'partner_id': '${this.partner_id}',
    };
    appSocket.socket.emit('acctepted_calling', data);
  }

  bool toggleAudio() {
    emit(CallingAudioNewState());
    if (localStream != null) {
      final audioTrack = localStream!.getAudioTracks()[0];
      if (audioTrack != null) {
        final bool audioEnabled = audioTrack.enabled = !audioTrack.enabled;
        this.audioEnabled = audioEnabled;
        // this.isAudio = audioEnabled;

        emit(CallingAudioLoadedState());
        return audioEnabled;
      }
    }
    emit(CallingAudioLoadedState());
    return false;
  }
}
