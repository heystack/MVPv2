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

ActiveRecord::Schema.define(:version => 20111212022155) do

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "stack_id"
    t.integer  "user_id"
    t.integer  "votes"
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

  create_table "stacks", :force => true do |t|
    t.string   "attr_biggest_desc"
    t.string   "attr_comparison_text"
    t.string   "attr_email_buttons"
    t.string   "attr_email_units"
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
  end

  create_table "users", :force => true do |t|
    t.integer  "admin"
    t.string   "email"
    t.string   "password"
    t.string   "name"
    t.string   "salt"
    t.integer  "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
