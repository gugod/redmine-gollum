class AddDirectoryToGollumWikis < ActiveRecord::Migration
  def self.up
    add_column :gollum_wikis, :directory, :string, :default => 'doc'
  end

  def self.down
    remove_column :gollum_wikis, :directory
  end
end
