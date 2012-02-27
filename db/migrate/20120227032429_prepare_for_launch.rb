class PrepareForLaunch < ActiveRecord::Migration
  def up
    drop_table :users
    drop_table :responses
    drop_table :comments
    drop_table :replies
    drop_table :user_communities
    drop_table :votes
  end

  def down
    create_table "comments", :force => true do |t|
      t.string   "content",    :limit => 5000
      t.integer  "stack_id"
      t.integer  "user_id"
      t.integer  "votes"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "replies", :force => true do |t|
      t.string   "content",    :limit => 5000
      t.integer  "comment_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "responses", :force => true do |t|
      t.string   "qualifier1"
      t.integer  "stack_id"
      t.integer  "user_id"
      t.float    "value"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "outlier"
    end

    create_table "user_communities", :force => true do |t|
      t.integer  "community_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "users", :force => true do |t|
      t.boolean  "admin",      :default => false
      t.string   "email"
      t.string   "password"
      t.string   "name"
      t.string   "salt"
      t.integer  "zipcode"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "subscribed"
    end

    create_table "votes", :force => true do |t|
      t.integer  "user_id"
      t.integer  "comment_id"
      t.string   "type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
