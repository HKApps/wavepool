class User < ActiveRecord::Base
  def self.find_or_create_by_sms(sms_receiver)
    user = self.where(
      phone_number: sms_receiver.from,
    ).first_or_initialize do |u|
      u.playlist_id = sms_receiver.body
    end

    user.save if user.changed?
    user
  end
end
