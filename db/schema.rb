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

ActiveRecord::Schema.define(:version => 20110118094731) do

  create_table "attendances", :id => false, :force => true do |t|
    t.integer  "conference_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attendances", ["conference_id"], :name => "index_attendances_on_conference_id"
  add_index "attendances", ["user_id"], :name => "index_attendances_on_user_id"

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "lock_version",   :default => 0
    t.string   "name"
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"

  create_table "category_conferences", :force => true do |t|
    t.integer  "conference_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_conferences", ["category_id"], :name => "index_category_conferences_on_category_id"
  add_index "category_conferences", ["conference_id"], :name => "index_category_conferences_on_conference_id"

  create_table "conferences", :force => true do |t|
    t.integer  "lock_version",                                    :default => 0
    t.string   "name"
    t.integer  "creator_user_id"
    t.integer  "series_id"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "description"
    t.string   "location"
    t.decimal  "lat",             :precision => 15, :scale => 10
    t.decimal  "lng",             :precision => 15, :scale => 10
    t.string   "venue"
    t.string   "accomodation"
    t.text     "howtofind"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conferences", ["creator_user_id"], :name => "index_conferences_on_creator_user_id"
  add_index "conferences", ["series_id"], :name => "index_conferences_on_series_id"

  create_table "member_of_series", :force => true do |t|
    t.integer  "series_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "member_of_series", ["series_id"], :name => "index_member_of_series_on_series_id"
  add_index "member_of_series", ["user_id"], :name => "index_member_of_series_on_user_id"

  create_table "rcd_statuses", :force => true do |t|
    t.integer  "inviter_user_id"
    t.integer  "invitee_user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rcd_statuses", ["invitee_user_id"], :name => "index_rcd_statuses_on_invitee_user_id"
  add_index "rcd_statuses", ["inviter_user_id"], :name => "index_rcd_statuses_on_inviter_user_id"

  create_table "series", :force => true do |t|
    t.integer  "version",    :default => 0
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128,                                 :default => "", :null => false
    t.string   "password_salt",                                                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                                                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.integer  "lock_version",                                                        :default => 0
    t.string   "username"
    t.string   "fullname"
    t.string   "town"
    t.string   "country"
    t.decimal  "lat",                                 :precision => 15, :scale => 10
    t.decimal  "lng",                                 :precision => 15, :scale => 10
    t.boolean  "is_administrator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  add_foreign_key "attendances", ["conference_id"], :name => "index_attendances_on_conference_id"
  add_foreign_key "attendances", ["user_id"], :name => "index_attendances_on_user_id"

  add_foreign_key "category_conferences", ["category_id"], :name => "index_category_conferences_on_category_id"
  add_foreign_key "category_conferences", ["conference_id"], :name => "index_category_conferences_on_conference_id"

  add_foreign_key "conferences", ["creator_user_id"], :references => "users", :name => "index_conferences_on_creator_user_id"
  add_foreign_key "conferences", ["series_id"], :name => "index_conferences_on_series_id"

  add_foreign_key "member_of_series", ["series_id"], :name => "index_member_of_series_on_series_id"
  add_foreign_key "member_of_series", ["user_id"], :name => "index_member_of_series_on_user_id"

  add_foreign_key "rcd_statuses", ["invitee_user_id"], :references => "users", :name => "index_rcd_statuses_on_invitee_user_id"
  add_foreign_key "rcd_statuses", ["inviter_user_id"], :references => "users", :name => "index_rcd_statuses_on_inviter_user_id"

end
