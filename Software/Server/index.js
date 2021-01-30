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