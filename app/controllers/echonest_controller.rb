require 'echonest'
require 'song_parser'
require 'twilio_sms_receiver'
require 'redis_stack'

class EchonestController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def search
    results = Echonest.search(song_parser.artist, song_parser.title)
    songs   = results[:response][:songs]
    redis_stack.push songs
    twiml_response = Twilio::TwiML::Response.new do |r|
      r.Sms "Choose which song you would like to add to the queue:"
    end
    render xml: twiml_response.text
  end

  private

  def song_parser
    @song_parser ||= SongParser.new(sms_receiver.body)
  end

  def sms_receiver
    @sms_receiver ||= TwilioSmsReceiver.from_params(params.clone)
  end

  def redis_stack
    @redis_stack ||= RedisStack.new(sms_receiver.cache_key)
  end

end
