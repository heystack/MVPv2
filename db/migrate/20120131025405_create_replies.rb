class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.string :content
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
