class Echonest
  def self.search(artist, title)
    new(artist, title).api_request
  end

  def initialize(artist, title)
    @url = ApiUrl.new.final(artist, title)
  end

  def api_request
    ResponseParser.new JSON.parse(RestClient.get(@url), symbolize_names: true)
  end

  private

  class ApiUrl
    def final(artist, title)
      URI.escape construct_url(artist, title)
    end

    def construct_url(artist, title)
      base_url + base_params << "&artist=#{artist}&title=#{title}"
    end

    def base_params
      "&format=json&results=3&bucket=id:rdio-US&bucket=tracks&limit=true"
    end

    def base_url
      "http://developer.echonest.com/api/v4/song/search?api_key=#{ENV["ECHONEST_API_KEY"]}"
    end
  end

  class ResponseParser
    attr_reader :response, :status, :songs

    def initialize(raw)
      return unless raw
      @response = raw
      @status   = raw[:response][:status]
      @songs    = raw[:response][:songs].map { |s| SongParser.new(s) }
    end

    def to_sms_choices
      final_text = ''
      songs.each_with_index do |song, i|
        final_text << "\n#{i+1}. #{song.title} - #{song.artist_name}"
      end
      final_text
    end
  end

  class SongParser
    include ActiveModel::Model

    attr_accessor :title, :artist_name, :id, :tracks, :artist_id, :audio_md5

    def initialize(*args)
      super
    end
  end
end
