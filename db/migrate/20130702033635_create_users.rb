class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :phone_number
      t.integer :playlist_id
    end
  end
end
