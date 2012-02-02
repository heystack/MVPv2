class AddIconToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :icon, :string
  end
end
