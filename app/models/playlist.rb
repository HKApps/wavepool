class Playlist < ActiveRecord::Base
  def self.from_rdio(response)
    response.each do |playlist|
      next if self.find_by rdio_key: playlist["key"]
      self.create(name: playlist["name"], rdio_key: playlist["key"])
    end
  end
end
