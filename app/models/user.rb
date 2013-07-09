class User < ActiveRecord::Base
  has_many :playlists

  def self.find_or_create_by_sms(sms_receiver)
    user = self.where(phone_number: sms_receiver.from).first_or_initialize
    user.playlist_id = Playlist.find_by(access_code: sms_receiver.body).id
    user.save if user.changed?
    user
  end

  def playlist
    Playlist.find_by id: playlist_id
  end

  def clear_tokens!
    access_token        = nil
    access_token_secret = nil
    self.save!
  end
end
