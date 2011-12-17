class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :admin, :default => false
      t.string :email
      t.string :password
      t.string :name
      t.string :salt
      t.integer :zipcode

      t.timestamps
    end
  end
end
