require 'rdio_songs'
require 'redis_stack'
require 'sms_song_parser'
require 'twilio_sms_receiver'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def sms_song_parser
    @sms_song_parser ||= SmsSongParser.new(sms_receiver.body)
  end

  def sms_receiver
    @sms_receiver ||= TwilioSmsReceiver.from_params(params.clone)
  end

  def redis_stack
    @redis_stack ||= RedisStack.new(sms_receiver.cache_key)
  end

  def rdio_songs
    @rdio_songs ||= RdioSongs.new(playlist_owner) if playlist_owner
  end

  def authenticate
    redirect_to login_path unless current_user
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id] if session[:user_id]
  end
  helper_method :current_user

  def requester
    @requester ||= User.find_or_create_by_sms(sms_receiver)
  end

  def playlist_owner
    @playlist_owner ||= sms_receiver.playlist.user
  end
end
