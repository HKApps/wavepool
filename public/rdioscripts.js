$(document).ready(function(){
  playlist_key = $('#playlistKey').html();
  song_index = 0;
  duration = 1; // track the duration of the currently playing track
  R.ready(function() {
    // update the track views when tracks change
    R.player.on("change:playingTrack", function(playingTrack) {
      if (playingTrack) {
        duration = playingTrack.attributes.duration;
        song_index = R.player.sourcePosition();
        $('#art').attr('src', playingTrack.attributes.icon);
        $('#track').text(playingTrack.attributes.name);
        $('#artist').text(playingTrack.attributes.artist);
        if ((R.player.playingSource().attributes.length - song_index) == 1){
        }
      }
    });

    R.player.on("change:position", function(position) {
      $('#position').css('width', Math.floor(100*position/duration)+'%');
    });

    R.player.on("change:playState", function(state) {
      if (state == 2 & song_index > 0){
        tryAndAddNextSong(playlist_key, song_index);
      }
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
  R.player.play({source: playlist_key});
}

function tryAndAddNextSong(playlist_key, song_index){
  R.request({
    method: "getUserPlaylists",
    content: {
      user: "s8453927"
    },
    success: function(response){
      playlists = response.result;
      for (i in playlists){
        if (playlists[i].key == playlist_key){
          if (playlists[i].length > song_index){
            R.player.play({source: playlist_key, index: song_index + 1});
          }
        }
      }
    },
    error: function(response){
      console.log(response.message);
    }
  });
}
