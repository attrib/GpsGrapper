paintTracking = (data) ->
  console.log 'paint', data

window.onload = () ->

  if navigator.geolocation?

    socket = io.connect "http://#{window.location.hostname}:8080/game"
    socket.on 'connect', () ->
      console.log 'connected'
      watchID = null

      socket.emit 'new player', {nickname: 'me', team: 'thief'}

      socket.on 'start tracking', () ->
        console.log "start tracking"
        watchID = navigator.geolocation.watchPosition (position) ->
          data = {
            long: position.coords.longitude,
            lat: position.coords.latitude,
            accuracy: position.coords.accuracy
          }
          paintTracking data
        , null, {enableHighAccuracy:true, maximumAge:30000, timeout:27000}

      socket.on 'disconnect', () ->
        navigator.geolocation.clearWatch(watchID)

      socket.on 'new tracking', (data) ->
        paintTracking data

  else
    alert("You need a browser with geolocation support.")

