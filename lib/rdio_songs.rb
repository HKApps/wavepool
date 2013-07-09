require 'rdio'

class RdioSongs
  def initialize(current_user)
    @rdio = Rdio.new([ENV["RDIO_CONSUMER_KEY"], ENV["RDIO_CONSUMER_SECRET"]],
                    [current_user.access_token, current_user.access_token_secret])
  end

  def search(artist, title)
    ResponseParser.new @rdio.call('search',
      query: "#{artist} #{title}",
      types: "track",
      count: "3"
    )
  end

  class ResponseParser
    attr_reader :response, :songs

    def initialize(response)
      @response       = response
      @songs          = response["result"]["results"].map { |s| SongParser.new(s) }
    end

    def to_sms_choices
      final_text = "Which song?\n"
      songs.each_with_index do |song, i|
        final_text << "#{i+1}. #{song.name.truncate(28)} - #{song.artist.truncate(14)}\n"
      end
      final_text
    end
  end

  class SongParser
    include ActiveModel::Model

    [:radioKey,
     :baseIcon,
     :canDownloadAlbumOnly,
     :radio,
     :artistUrl,
     :duration,
     :album,
     :isClean,
     :albumUrl,
     :shortUrl,
     :albumArtist,
     :canStream,
     :embedUrl,
     :type,
     :price,
     :trackNum,
     :albumArtistKey,
     :key,
     :icon,
     :canSample,
     :name,
     :isExplicit,
     :artistKey,
     :url,
     :icon400,
     :artist,
     :canDownload,
     :length,
     :canTether,
     :albumKey].each { |attr| attr_accessor attr }

    def initialize(*args)
      super
    end
  end
end
