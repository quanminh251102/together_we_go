import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/url/config.dart';

class AppSocket {
  late IO.Socket _socket;
  IO.Socket get socket => _socket;
  init(String userId) {
    try {
      _socket.dispose();
    } catch (e) {
      print(e);
    }

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'user_id': '$userId'}).build(),
    );
    _socket.connect();
  }
}

final appSocket = AppSocket();
