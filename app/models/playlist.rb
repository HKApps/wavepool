class Playlist < ActiveRecord::Base
  belongs_to :user

  def self.from_rdio(response, user_id)
    response.each do |playlist|
      next if self.find_by rdio_key: playlist["key"]
      self.create(name: playlist["name"], rdio_key: playlist["key"], user_id: user_id)
    end
  end
end
