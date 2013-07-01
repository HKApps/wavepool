class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name, null: false
      t.string :rdio_key, null: false
    end

    add_index :playlists, :rdio_key, unique: true
  end
end
