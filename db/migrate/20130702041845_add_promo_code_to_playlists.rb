class AddPromoCodeToPlaylists < ActiveRecord::Migration
  def change
    add_column :playlists, :access_code, :string
  end
end
