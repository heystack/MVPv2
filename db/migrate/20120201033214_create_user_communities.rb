class CreateUserCommunities < ActiveRecord::Migration
  def change
    create_table :user_communities do |t|
      t.integer :community_id
      t.integer :user_id

      t.timestamps
    end
  end
end
