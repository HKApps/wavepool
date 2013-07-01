class PlaylistsController < ApplicationController
  def index
    rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                    [session[:access_token], session[:access_token_secret]])
    @playlists = rdio.call('getPlaylists')["result"]["owned"]
    Playlist.from_rdio(@playlists)
  end

  def show
    @playlist = Playlist.find_by rdio_key: params[:rdio_key]
  end
end
