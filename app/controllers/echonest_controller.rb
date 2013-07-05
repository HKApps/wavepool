class EchonestController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def search
    redis_stack.push echonest.response
    twiml_response = Twilio::TwiML::Response.new do |r|
      r.Sms base_response << echonest.to_sms_choices
    end
    render xml: twiml_response.text
  end

  private

  def base_response
    "Choose which song you would like to add to the queue:"
  end

end
