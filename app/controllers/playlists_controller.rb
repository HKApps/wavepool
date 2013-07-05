require 'rdio'

class PlaylistsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:add_song]

  def index
    rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                    [current_user.access_token, current_user.access_token_secret])
    @playlists = rdio.call('getPlaylists')["result"]["owned"]
    Playlist.from_rdio(@playlists, current_user.id)
  end

  def show
    @playlist = Playlist.find_by rdio_key: params[:rdio_key]
  end

  def add_song
    result = Echonest::ResponseParser.new redis_stack.last
    if result.songs.present?
      foreign_id     = result.songs[sms_receiver.body.to_i - 1].tracks.first[:foreign_id]
      rdio_id        = foreign_id.split(':').last
      playlist_owner = sms_receiver.playlist.user
      rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                      [playlist_owner.access_token, playlist_owner.access_token_secret])
      rdio.call("addToPlaylist", playlist: sms_receiver.playlist.rdio_key, tracks: rdio_id)
      redis_stack.pop
      head :ok
    else
      twiml_response = Twilio::TwiML::Response.new do |r|
        r.Sms "Sorry! We couldn't process your request :("
      end
      render xml: twiml_response.text
    end
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
