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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150915201703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "assignable_id"
    t.string   "assignable_type"
    t.string   "description"
    t.boolean  "closed",          default: false
    t.string   "result"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "assignments", ["assignable_type", "assignable_id"], name: "index_assignments_on_assignable_type_and_assignable_id", using: :btree
  add_index "assignments", ["user_id"], name: "index_assignments_on_user_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "inn"
    t.integer  "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "historyable_id"
    t.string   "historyable_type"
    t.string   "state"
    t.integer  "user_id"
    t.text     "description"
    t.text     "new_values"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "histories", ["historyable_type", "historyable_id"], name: "index_histories_on_historyable_type_and_historyable_id", using: :btree
  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree

  create_table "req_purchases", force: :cascade do |t|
    t.string   "state",        default: "new"
    t.integer  "last_user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "name"
    t.integer  "money"
  end

  add_index "req_purchases", ["last_user_id"], name: "index_req_purchases_on_last_user_id", using: :btree

  create_table "req_reassigns", force: :cascade do |t|
    t.string   "state",          default: "new"
    t.integer  "last_user_id"
    t.string   "name"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "role"
    t.integer  "money"
    t.integer  "old_manager_id"
    t.integer  "new_manager_id"
    t.integer  "client_id"
    t.text     "info"
  end

  add_index "req_reassigns", ["client_id"], name: "index_req_reassigns_on_client_id", using: :btree
  add_index "req_reassigns", ["last_user_id"], name: "index_req_reassigns_on_last_user_id", using: :btree
  add_index "req_reassigns", ["new_manager_id"], name: "index_req_reassigns_on_new_manager_id", using: :btree
  add_index "req_reassigns", ["old_manager_id"], name: "index_req_reassigns_on_old_manager_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "assignments", "users"
  add_foreign_key "histories", "users"
  add_foreign_key "req_reassigns", "clients"
end
