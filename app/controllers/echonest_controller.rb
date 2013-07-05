class EchonestController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def search
    redis_stack.push echonest.response
    message = (echonest.songs.present? ? base_response << echonest.to_sms_choices : no_result_response)
    twiml_response = Twilio::TwiML::Response.new do |r|
      r.Sms message
    end
    render xml: twiml_response.text
  end

  private

  def base_response
    "Choose which song you would like to add to the queue:"
  end

  def no_result_response
    "Sorry, we can’t find that one! Check your spelling and try again!"
  end
end
