class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :content, :limit => 1000
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
