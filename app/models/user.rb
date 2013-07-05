class User < ActiveRecord::Base
  def self.find_or_create_by_sms(sms_receiver)
    user = self.where(
      phone_number: sms_receiver.from,
    ).first_or_initialize do |u|
      u.playlist_id = Playlist.find_by(access_code: sms_receiver.body).id
    end

    user.save if user.changed?
    user
  end

  def playlist
    Playlist.find_by id: playlist_id
  end
end
