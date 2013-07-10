class SongSearchController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def search
    results = rdio_songs.search(sms_song_parser.artist, sms_song_parser.title)
    redis_stack.push results.response
    message = (results.songs.present? ? results.to_sms_choices : no_result_response)
    twiml_response = Twilio::TwiML::Response.new do |r|
      r.Sms message
    end
    render xml: twiml_response.text
  end

  private

  def no_result_response
    "Sorry! We couldn't process your request! :("
  end
end
