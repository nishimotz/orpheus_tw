class AddCompositionToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :composition, :string
  end

  def self.down
    remove_column :songs, :composition
  end
end
