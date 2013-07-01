var duration = 1; // track the duration of the currently playing track
    $(document).ready(function() {
      $('#rdio').bind('ready.rdio', function() {
        $(this).rdio().play('a1228601');
      });
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
        if (playState == 0) { // paused
          $('#play').show();
          $('#pause').hide();
        } else {
          $('#play').hide();
          $('#pause').show();
        }
      });
      // this is a valid playback token for localhost.
      // but you should go get your own for your own domain.
      $('#rdio').rdio('GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc=');

      $('#previous').click(function() { $('#rdio').rdio().previous(); });
      $('#play').click(function() { $('#rdio').rdio().play(); });
      $('#pause').click(function() { $('#rdio').rdio().pause(); });
      $('#next').click(function() { $('#rdio').rdio().next(); });
    });
