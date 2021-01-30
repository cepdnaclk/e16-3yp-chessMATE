import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'websockets.dart';


// Application-level global variable
GameCommunication game = new GameCommunication();

class GameCommunication {
  
  static final GameCommunication _game = new GameCommunication._internal();

  // At first initialization, the player has not yet provided any name
  String _playerName = "";

  // Before the "join" action, the player has no unique ID
  String _playerID = "";

  factory GameCommunication(){
    return _game;
  }

  GameCommunication._internal(){

    // Let's initialize the WebSockets communication
    sockets.initCommunication();

    // // and ask to be notified as soon as a message comes in
    // sockets.addListener(_onMessageReceived);
  }


}