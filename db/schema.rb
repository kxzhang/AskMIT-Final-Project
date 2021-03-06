# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20121210045850) do

  create_table "answers", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.boolean  "is_anon"
  end

  create_table "follows", :force => true do |t|
    t.integer "user_id"
    t.integer "question_id"
  end

  create_table "hashtags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_used"
  end

  create_table "hashtags_questions", :id => false, :force => true do |t|
    t.integer "hashtag_id"
    t.integer "question_id"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.boolean  "read"
    t.string   "type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "modifier_id"
    t.string   "question_title"
    t.boolean  "is_anon"
  end

  create_table "questions", :force => true do |t|
    t.text     "details"
    t.text     "title"
    t.integer  "user_id"
    t.integer  "hashtag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score"
    t.tsvector "tsv"
    t.boolean  "is_anon"
  end

  add_index "questions", ["tsv"], :name => "questions_tsv_idx"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "confirm"
    t.string   "token"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "score"
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
