class AddUseragentToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :useragent, :string
  end

  def self.down
    remove_column :songs, :useragent
  end
end
