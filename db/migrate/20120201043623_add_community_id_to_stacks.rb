class AddCommunityIdToStacks < ActiveRecord::Migration
  def change
    add_column :stacks, :community_id, :integer
  end
end
