$(document).ready(function(){
  playlist_key = $('#playlistKey').html();
  user_key = $('#userKey').html();
  playState = 2; // start with player stopped
  song_index = 0;
  duration = 0; // track the duration of the currently playing track
  songPlayed = false;
  R.ready(function() {
    // update the track views when tracks change
    R.player.on("change:playingTrack", function(playingTrack) {
      if (playingTrack) {
        songPlayed = true;
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
      playState = state;
      if (state == 2 && songPlayed){
        tryAndAddNextSong(user_key, playlist_key, song_index + 1);
      }
    });

    // playlist controls
    $('#start').click(function() {
      tryAndAddNextSong(user_key, playlist_key, song_index);
      $('#startPrompt').hide();
      $('#rdioPlayer').show();
    });
    $('#play').click(function() {
      if (playState == 2){
        song_index = 0;
        songPlayed = false;
        tryAndAddNextSong(user_key, playlist_key, song_index);
      }else {
        R.player.play();
      }
    });
    $('#pause').click(function() { R.player.pause(); });
    $('#previous').click(function() { R.player.previous(); });
    $('#next').click(function() { R.player.next(); });
  });
});

function setPlaylist(source, index){
  R.player.play({source: source, index: index});
}

function tryAndAddNextSong(user_key, playlist_key, song_index){
  R.request({
    method: "getUserPlaylists",
    content: {
      user: user_key
    },
    success: function(response){
      playlists = response.result;
      for (i in playlists){
        if (playlists[i].key == playlist_key){
          if (playlists[i].length > song_index){
            setPlaylist(playlist_key, song_index);
          }
        }
      }
    },
    error: function(response){
      console.log(response.message);
    }
  });
}
