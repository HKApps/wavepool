class Echonest
  def self.search(artist, title)
    new.api_request(ApiUrl.new.final(artist, title))
  end

  def api_request(url)
    JSON.parse(RestClient.get(url), symbolize_names: true)
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
end
