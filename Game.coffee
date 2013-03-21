Player = require './Player'

class Game
  @STATUS_SETUP: 0
  @STATUS_RUNNING: 1
  @STATUS_FINISHED: 2

  status: @STATUS_SETUP
  players: []

  constructor: () ->
    @status = @STATUS_SETUP
    @players

  addPlayer: (nick, team) ->
    player = new Player(nick, team);
    @players.push player
    player

  removePlayer: (Player) ->


module.exports = Game
