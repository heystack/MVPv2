class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.integer :community_id
      t.string :name
      t.string :desc
      t.string :type
      t.string :logo

      t.timestamps
    end
  end
end
