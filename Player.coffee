
class Player
  trackings: []
  id: 0

  constructor: (@nickname, @team) ->

  track: (long, lat, accuracy) ->
    @trackings.push {
      long: long,
      lat: lat,
      accuracy: accuracy,
      time: new Date()
    }


module.exports = Player
