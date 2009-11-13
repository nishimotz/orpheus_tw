class AddTextToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :text, :string
  end

  def self.down
    remove_column :songs, :text
  end
end
