var duration = 1; // track the duration of the currently playing track

$(document).ready(function(){
  R.ready(function() {
    // update the track views when tracks change
    R.player.on("change:playingTrack", function(playingTrack) {
      if (playingTrack) {
        p = playingTrack;
        duration = playingTrack.attributes.duration;
        $('#art').attr('src', playingTrack.attributes.icon);
        $('#track').text(playingTrack.attributes.name);
        $('#artist').text(playingTrack.attributes.artist);
      }
    });

    R.player.on("change:position", function(position) {
      $('#position').css('width', Math.floor(100*position/duration)+'%');
    });

    R.player.on("change:playState", function(state) {
      console.log(state);
    });

    // playlist controls
    $('#start').click(function() {
      setPlaylist();
      $('#startPrompt').hide();
      $('#rdioPlayer').show();
    });
    $('#play').click(function() {
      if (R.player.playState() == 2){
        setPlaylist();
      }else {
        R.player.play();
      }

    });
    $('#pause').click(function() { R.player.pause(); });
    $('#previous').click(function() { R.player.previous(); });
    $('#next').click(function() { R.player.next(); });
  });
});

function setPlaylist(){
  playlist = $('#playlistKey').html();
  R.player.play({source: playlist});
}
