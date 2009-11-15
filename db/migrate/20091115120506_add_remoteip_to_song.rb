class AddRemoteipToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :remoteip, :string
  end

  def self.down
    remove_column :songs, :remoteip
  end
end
