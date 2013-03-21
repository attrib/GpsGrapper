express = require("express")
app = express()
server = require("http").createServer app
io = require("socket.io").listen server


# PORT
server.listen(8080)
publicDir = __dirname + '/public'

app.use express.static publicDir

Game = require './Game'

game = new Game();

gameSockets = io.of('/game').on 'connection', (socket) ->
  player = null;
  socket.on 'new player', (data) ->
    player = game.addPlayer(data.nickname, data.team)
    socket.emit 'start tracking'

  socket.on 'track', (data) ->
    if player?
      console.log "received tracking", data
      player.track(data.long, data.lat, data.accuracy)
      data.id = player.id
      socket.broadcast.emit 'new tracking', data

  socket.on 'disconnect', () ->
    if player?
      game.removePlayer player
