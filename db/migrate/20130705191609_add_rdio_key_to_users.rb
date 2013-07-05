class AddRdioKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rdio_key, :string
  end
end
