// Adapt to the listening port number you want to use
var webSocketsServerPort = 3000; 

// websocket and http servers
var webSocketServer = require('websocket').server;
var http = require('http');

/**
* HTTP server to implement WebSockets
*/
var server = http.createServer(function(request, response) {});

server.listen(webSocketsServerPort, function() {
    console.log((new Date()) + " Server is listening on port "
        + webSocketsServerPort);
  });

/**
* WebSocket server
*/
var wsServer = new webSocketServer({
    // WebSocket server is tied to a HTTP server. WebSocket request is just an enhanced HTTP request. 
    httpServer: server
});

// -----------------------------------------------------------
// List of all players
// -----------------------------------------------------------
var Players = [];

// player detail structure
function Player(id, connection){
    this.id = id;
    this.connection = connection;
    this.name = "";
    this.opponentIndex = null;
    this.index = Players.length;
}

Player.prototype = {
    getId: function(){
        return {name: this.name, id: this.id};
    },
    setOpponent: function(id){
        var self = this;
        Players.forEach(function(player, index){
            if (player.id == id){
                self.opponentIndex = index;
                Players[index].opponentIndex = self.index;
                return false;
            }
        });
    }
};

// This callback function is called every time someone tries to connect to the WebSocket server
wsServer.on('request', function(request) {
    
    var connection = request.accept(null, request.origin); 
    
    // New Player has connected.  So let's record its socket
    var player = new Player(request.key, connection);

    // Add the player to the list of all players
    Players.push(player);

    // We need to return the unique id of that player to the player itself
    connection.sendUTF(JSON.stringify({action: 'connect', data: player.id}));

    // Listen to any message sent by that player
    connection.on('message', function(data) {

        // Process the requested action
        var message = JSON.parse(data.utf8Data);

        switch(message.action){

            //
            // When the user sends the "join" action, he provides a name.
            // Let's record it and as the player has a name,
            //
            case 'join':
                player.name = message.data;
                console.log(player.name);
                break;

            case 'players_list':
                BroadcastPlayersList();
                break;
                
            case 'resign':
                console.log('resigned');
                    Players[player.opponentIndex]
                    .connection
                    .sendUTF(JSON.stringify({'action':'resigned'}));

                    setTimeout(function(){
                    Players[player.opponentIndex].opponentIndex = player.opponentIndex = null;
                    }, 0);
                break;

            //
            // A player initiates a new game.
            // Let's create a relationship between the 2 players and
            // notify the other player that a new game starts
            // 
            case 'new_game':
                player.setOpponent(message.data);
                Players[player.opponentIndex]
                .connection
                .sendUTF(JSON.stringify({'action':'new_game', 'data': player.name}));
                break;

            //
            // A player sends a move.  Let's forward the move to the other player
            //
            case 'play':
                Players[player.opponentIndex]
                .connection
                .sendUTF(JSON.stringify({'action':'play', 'data': message.data}));
                break;
                
        }
    });

});

// ---------------------------------------------------------
// Routine to broadcast the list of all players to everyone
// ---------------------------------------------------------
function BroadcastPlayersList(){
    var playersList = [];
    Players.forEach(function(player){
        if (player.name !== ''){
            playersList.push(player.getId());
        }
    });

    var message = JSON.stringify({
        'action': 'b_players_list',
        'data': playersList
    });

    Players.forEach(function(player){
        player.connection.sendUTF(message);
    });
}