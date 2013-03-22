window.onload = () ->

  canvas = document.getElementById "map"
  canvas.height = document.height
  canvas.width = canvas.height * 3790 / 2810 # keep image ratio
  mapContext = canvas.getContext "2d"
  map = new Image()
  map.onload = () ->
    console.log "map loaded"
    mapContext.drawImage map, 0, 0, canvas.width, canvas.height
  map.src = "/BeerZone5_Karte_mit_Flaggenpunkten_final.png"

  debugFirstPosition = null

  normalizePosition = (data) ->
    # for debug, always start in the middle
    # THIS POSITION HAS TO BE FIXED SOMEHOW TO THE MAP
    if !debugFirstPosition?
      debugFirstPosition = data
      return {y: canvas.height/2, x: canvas.width/2}
    data.long -= debugFirstPosition.long
    data.lat  -= debugFirstPosition.lat

    RADIANS = 57.2957795
    angle = 0 # 0 / RADIANS ?
    radianLat = debugFirstPosition.lat / RADIANS
    x = data.long * ((111415.13 * Math.cos(radianLat))- (94.55 * Math.cos(3.0*radianLat)) + (0.12 * Math.cos(5.0*radianLat)))
    y = data.lat * (111132.09 - (566.05 * Math.cos(2.0*radianLat))+ (1.20 * Math.cos(4.0*radianLat)) - (0.002 * Math.cos(6.0*radianLat)))

    r = Math.sqrt x*x + y*y
    ct = x/r
    st = y/r
    x = r * ( ct * Math.cos angle + st * Math.sin angle )
    y = r * ( st * Math.cos angle - ct * Math.sin angle )

    # 1350x1000m field
    x = x * canvas.width / 1350 + canvas.width / 2
    y = -1 * y * canvas.height / 1000 + canvas.height / 2
    {x: x, y: y}

  paintTracking = (data) ->
    pos = normalizePosition(data)
    console.log 'paint', pos
    if (pos.x? && pos.y?)
      mapContext.fillStyle = "#FF0000"
      mapContext.arc pos.x, pos.y, 5, 0, 2*Math.PI, false
      mapContext.fill()


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
          console.log "new position", data
          paintTracking data
        , null, {enableHighAccuracy:true, maximumAge:30000, timeout:27000}

      socket.on 'disconnect', () ->
        navigator.geolocation.clearWatch(watchID)

      socket.on 'new tracking', (data) ->
        console.log 'new tracking', data
        paintTracking data

  else
    alert("You need a browser with geolocation support.")

