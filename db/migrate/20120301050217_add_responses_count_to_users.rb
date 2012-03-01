class AddResponsesCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :responses_count, :integer, :default => 0

    User.reset_column_information
    User.find(:all).each do |u|
      User.update_counters u.id, :responses_count => u.responses.length
    end
  end

  def self.down
    remove_column :responses, :responses_count
  end
end
