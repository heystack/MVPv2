class ChangeZipcodeToString < ActiveRecord::Migration
  def self.up
    rename_column :users, :zipcode, :zipcode_integer
    add_column :users, :zipcode, :string

    User.reset_column_information
    User.find_each { |u| u.update_attribute(:zipcode, u.zipcode_integer) } 
    remove_column :users, :zipcode_integer
  end
end