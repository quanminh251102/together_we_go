import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/url/config.dart';

class AppSocket {
  late IO.Socket _socket;
  IO.Socket get socket => _socket;
  init() {
    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']).setQuery({'private': ''}).build(),
    );
  }
}

final appSocket = AppSocket();
