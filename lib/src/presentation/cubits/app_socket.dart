import 'package:socket_io_client/socket_io_client.dart' as IO;

const baseUrl = 'http://192.168.1.19:8080';

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
