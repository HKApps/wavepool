class ConnectController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def connect
    if sms_receiver.legit_access_code_present? && requester.present?
      twiml_response = Twilio::TwiML::Response.new do |r|
        r.Sms "Thanks! What song would you like to request?"
      end
      render xml: twiml_response.text
    elsif sms_receiver.song_decision?
      params.merge!(rdio_key: sms_receiver.playlist.rdio_key)
      redirect_to add_song_to_playlist_path(params)
    else
      params.merge!(rdio_key: sms_receiver.playlist.rdio_key)
      redirect_to song_search_path(params)
    end
  end
end
