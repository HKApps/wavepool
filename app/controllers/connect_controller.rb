class ConnectController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def connect
    if sms_receiver.legit_access_code_present? && requester.present?
      twiml_response = Twilio::TwiML::Response.new do |r|
        r.Sms "Thanks! What song would like to request?\n\nFormat your request like '[title] - [artist]'.\n\nFor example: Get Lucky - Daft Punk."
      end
      render xml: twiml_response.text
    elsif sms_receiver.song_request?
      params.merge!(rdio_key: sms_receiver.playlist.rdio_key)
      redirect_to echonest_search_path(params)
    elsif sms_receiver.song_decision?
      params.merge!(rdio_key: sms_receiver.playlist.rdio_key)
      redirect_to add_song_to_playlist_path(params)
    else
      twiml_response = Twilio::TwiML::Response.new do |r|
        r.Sms "Sorry! We couldn't process your request! :("
      end
      render xml: twiml_response.text
    end
  end
end
