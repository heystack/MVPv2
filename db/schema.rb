# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120131025405) do

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "stack_id"
    t.integer  "user_id"
    t.integer  "votes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.string   "content"
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
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stacks", :force => true do |t|
    t.string   "attr_biggest_desc"
    t.string   "attr_comparison_text"
    t.string   "attr_email_buttons",   :limit => 2000
    t.string   "attr_email_units"
    t.string   "attr_email_message",   :limit => 2000
    t.string   "attr_lowest_desc"
    t.string   "attr_lowest_legend"
    t.integer  "created_by"
    t.string   "madlibs_intro"
    t.string   "madlibs_label"
    t.string   "madlibs_units"
    t.string   "name"
    t.string   "question"
    t.integer  "sotd"
    t.string   "stem"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attr_type"
    t.string   "attr_tooltip_prefix"
    t.string   "attr_tooltip_units"
    t.string   "attr_rounding"
    t.string   "attr_comparison_1"
    t.string   "attr_comparison_2"
    t.string   "madlibs_1"
    t.string   "madlibs_1_type"
    t.string   "madlibs_1_label"
    t.string   "madlibs_1_option_1"
    t.string   "madlibs_1_option_2"
    t.string   "madlibs_1_option_3"
    t.string   "madlibs_1_option_4"
    t.string   "madlibs_1_option_5"
    t.string   "madlibs_1_option_6"
    t.string   "madlibs_1_option_7"
    t.string   "madlibs_1_option_8"
    t.string   "madlibs_1_option_9"
    t.string   "madlibs_1_option_10"
    t.string   "madlibs_1_option_11"
    t.string   "madlibs_1_option_12"
    t.string   "madlibs_2"
    t.string   "madlibs_2_label"
    t.string   "madlibs_3"
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

end
