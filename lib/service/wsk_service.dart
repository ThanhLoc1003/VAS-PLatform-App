import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/http_client.dart';

class WebSocketManager {
  late WebSocketChannel _webSocketChannel;

  WebSocketManager() {
    _webSocketChannel = WebSocketChannel.connect(Uri.parse('ws://$serverUrl'));
  }

  Stream<dynamic> get stream => _webSocketChannel.stream;

  void send(String data) {
    _webSocketChannel.sink.add(data);
  }

  void close() {
    _webSocketChannel.sink.close();
  }
}
