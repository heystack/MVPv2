class IncreaseCommentsLimit < ActiveRecord::Migration
  def self.up
    change_column :comments, :content, :string, :limit => 5000
    change_column :replies, :content, :string, :limit => 5000
  end
end
