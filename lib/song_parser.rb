class SongParser
  attr_reader :title, :artist

  def initialize(message)
    @message = message.split ' - '
    @title   = message[0]
    @artist  = message[1]
  end
end
