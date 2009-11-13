class AddComposeIdToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :compose_id, :integer
  end

  def self.down
    remove_column :songs, :compose_id
  end
end
