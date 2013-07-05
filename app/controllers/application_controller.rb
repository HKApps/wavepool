require 'echonest'
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

  def echonest
    @echonest ||= Echonest.search(sms_song_parser.artist, sms_song_parser.title)
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def user
    @user ||= User.find_or_create_by_sms(sms_receiver)
  end
end
