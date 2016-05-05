# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

myPosition = []
 
$(document).ready( -> 
    getCurrent = ->
      navigator.geolocation.getCurrentPosition(
        onSuccess,
        onError,
            enableHighAccuracy: false,
             timeout: 20000,
             maximumAge: 120000
      )
 
    onSuccess = (position) ->
        myPosition[0] = position.coords.latitude
        myPosition[1] = position.coords.longitude
        console.log myPosition[0]
        console.log myPosition[1]
        postData()
 
    onError = (err) ->
        switch err.code
          when 0 then message = 'Unknown error: ' + err.message
          when 1 then message = 'You denied permission to retrieve a position.'
          when 2 then message = 'The browser was unable to determine a position: ' + error.message
          when 3 then message = 'The browser timed out before retrieving the position.'
          else message = err.message
 
    postData = ->
        console.log myPosition[0]
        console.log myPosition[1]
        $.ajax({
            url: "/searches/get_location",
            data: 'lat=' + myPosition[0] + '&lon=' + myPosition[1]
        })
    $("#getLocation").click( ->
        location = $("input[name=full_location]").val();
        if location is ''
          getCurrent()
        else
          false
    )
)