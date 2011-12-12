class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.string :qualifier1
      t.integer :stack_id
      t.integer :user_id
      t.float :value

      t.timestamps
    end
  end
end
