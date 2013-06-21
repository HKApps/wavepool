class TwilioClient
  attr_reader :number, :account

  def initialize(acct_sid, auth_token, number)
    @account = Twilio::REST::Client.new(acct_sid, auth_token).account
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
