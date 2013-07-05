class TwilioSmsReceiver
  attr_reader :from, :body

  def self.from_params(params)
    from = params.delete(:From) { raise "Need a From param" }
    body = params.delete(:Body) { raise "Need a Body param" }

    new(from, body)
  end

  def initialize(from, body)
    @from = from
    @body = body
  end

  def song_decision?
    body.length == 1 && body.to_i < 4
  end

  def song_request?
    !!body.match(/\w+\s+(-)\s+\w+/)
  end

  def legit_access_code_present?
    (body.length == 4) && Playlist.find_by(access_code: body)
  end

  def playlist
    @playlist ||= (user.playlist || Playlist.find_by(access_code: body))
  end

  def user
    @user ||= User.find_by phone_number: from
  end

  def cache_key
    "#{user.phone_number}:#{playlist.rdio_key}"
  end
end
