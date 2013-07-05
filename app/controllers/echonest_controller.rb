require 'echonest'
require 'sms_song_parser'
require 'twilio_sms_receiver'
require 'redis_stack'

class EchonestController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def search
    redis_stack.push results[:response][:songs]
    twiml_response = Twilio::TwiML::Response.new do |r|
      r.Sms "Choose which song you would like to add to the queue:"
    end
    render xml: twiml_response.text
  end

  private

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
end
