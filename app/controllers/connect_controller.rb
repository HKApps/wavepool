require 'twilio_sms_receiver'

class ConnectController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def connect
    if user && sms_receiver.song_request?
      params.merge!(rdio_key: sms_receiver.playlist.rdio_key)
      redirect_to echonest_search_path(params)
    elsif sms_receiver.legit_access_code_present?
      twiml_response = Twilio::TwiML::Response.new do |r|
        r.Sms "Thanks! What song would like to request?\n\nFormat your request like '[title] - [artist]'.\n\nFor example: Get Lucky - Daft Punk."
      end
      render xml: twiml_response.text
    else
      twiml_response = Twilio::TwiML::Response.new do |r|
        r.Sms "Sorry! We couldn't process your request! :("
      end
      render xml: twiml_response.text
    end
  end

  private

  def sms_receiver
    @sms_receiver ||= TwilioSmsReceiver.from_params(params.clone)
  end

  def user
    @user ||= User.find_or_create_by_sms(sms_receiver)
  end
end
