var duration = 1; // track the duration of the currently playing track
var playstate = 2; // start with player stopped
$(document).ready(function() {

  $('#rdio').bind('ready.rdio', function() {
  });

  // update the track views when tracks change
  $('#rdio').bind('playingTrackChanged.rdio', function(e, playingTrack, sourcePosition) {
    if (playingTrack) {
      duration = playingTrack.duration;
      $('#art').attr('src', playingTrack.icon);
      $('#track').text(playingTrack.name);
      $('#artist').text(playingTrack.artist);
    }
  });

  $('#rdio').bind('positionChanged.rdio', function(e, position) {
    $('#position').css('width', Math.floor(100*position/duration)+'%');
  });

  $('#rdio').bind('playStateChanged.rdio', function(e, playState) {
    playstate = playState;
    // 0 → paused, 1 → playing, 2 → stopped, 3 → buffering, 4 → paused.
  });

  // this is a valid playback token for localhost
  $('#rdio').rdio('GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc=');

  // playlist controls
  $('#play').click(function() {
    if (playstate == 2) { // stopped
      setPlaylist();
    }
    else {
      $('#rdio').rdio().play();
    }
  });
  $('#pause').click(function() { $('#rdio').rdio().pause(); });
  $('#previous').click(function() { $('#rdio').rdio().previous(); });
  $('#next').click(function() { $('#rdio').rdio().next(); });
});

function setPlaylist(){
  playlist = $('#playlist_key').html(); // pretending this is response
  $('#rdio').rdio().play(playlist);
}
