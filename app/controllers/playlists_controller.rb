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

  def add_song
    # handle adding songs from the params
    # Perhaps consider using different controller to route suggestions
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

  def song_parser
    @song_parser ||= SongParser.new(sms_receiver.body)
  end

  def sms_receiver
    @sms_receiver ||= TwilioSmsReceiver.from_params(params.clone)
  end
end
