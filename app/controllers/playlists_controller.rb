require 'rdio'

class PlaylistsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_song]

  def index
    rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                    [session[:access_token], session[:access_token_secret]])
    @playlists = rdio.call('getPlaylists')["result"]["owned"]
    Playlist.from_rdio(@playlists)
  end

  def show
    @playlist = Playlist.find_by rdio_key: params[:rdio_key]
  end

  def add_song
    result     = Echonest::ResponseParser.new redis_stack.pop
    foreign_id = result.songs[sms_receiver.body.to_i].tracks.first[:foreign_id]
    rdio_id = foreign_id.split(':').last
    rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                    [session[:access_token], session[:access_token_secret]])
    rdio.call("addToPlaylist", playlist: sms_receiver.playlist.rdio_key, tracks: rdio_id)
  end

  def generate_access_code
    playlist = Playlist.find_by rdio_key: params[:rdio_key]
    playlist.access_code = generate_code
    if playlist.save
      redirect_to :back, notice: "Successfully created access code"
    else
      redirect_to :back, notice: "FAIL"
    end
  end

  private

  def generate_code
    SecureRandom.hex(2)
  end
end
