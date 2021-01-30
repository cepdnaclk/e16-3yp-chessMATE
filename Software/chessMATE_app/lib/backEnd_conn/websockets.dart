import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

// substitute your server's IP and port
const YOUR_SERVER_IP = '192.168.8.101';
const YOUR_SERVER_PORT = '3000';
const String _SERVER_ADDRESS = 'ws://$YOUR_SERVER_IP:$YOUR_SERVER_PORT';


class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets = new WebSocketsNotifications._internal();

  factory WebSocketsNotifications(){
    return _sockets;
  }

  WebSocketsNotifications._internal();

  // The WebSocket "open" channel
  IOWebSocketChannel _channel;

  // Is the connection established?
  bool _isOn = false;
  
  // Listeners 
  // List of methods to be called when a new message comes in.
  ObserverList<Function> _listeners = new ObserverList<Function>();

  // -----------------------------------
  // Closes the WebSocket communication
  // -----------------------------------
  reset(){
    if (_channel != null){
      if (_channel.sink != null){
        _channel.sink.close();
        _isOn = false;
      }
    }
  }

  // -----------------------------
  // Sends a message to the server
  // -----------------------------
  send(String message){
    if (_channel != null){
      if (_channel.sink != null && _isOn){
        _channel.sink.add(message);
      }
    }
  }


}