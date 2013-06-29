class TwilioClient
  attr_reader :number, :account

  def initialize(number)
    @account = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']).account
    @number  = number
  end

  def send_sms(receiver_num, message)
    account.sms.messages.create(
      from: number,
      to:   receiver_num,
      body: message
    )
  end
end
