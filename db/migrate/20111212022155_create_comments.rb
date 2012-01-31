class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :content, :limit => 2000
      t.integer :stack_id
      t.integer :user_id
      t.integer :votes

      t.timestamps
    end
  end
end
