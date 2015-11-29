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

ActiveRecord::Schema.define(version: 20151129000001) do

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

  create_table "inf_workgroup_members", force: :cascade do |t|
    t.integer  "req_workgroup_id"
    t.integer  "user_id"
    t.boolean  "main",             default: false
    t.string   "comment"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "inf_workgroup_members", ["req_workgroup_id"], name: "index_inf_workgroup_members_on_req_workgroup_id", using: :btree
  add_index "inf_workgroup_members", ["user_id"], name: "index_inf_workgroup_members_on_user_id", using: :btree

  create_table "req_purchases", force: :cascade do |t|
    t.string   "state",        default: "new"
    t.integer  "last_user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "name"
    t.integer  "money"
    t.string   "myfile"
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

  create_table "req_rolepurchases", force: :cascade do |t|
    t.string   "state",        default: "new"
    t.integer  "last_user_id"
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "money"
  end

  add_index "req_rolepurchases", ["last_user_id"], name: "index_req_rolepurchases_on_last_user_id", using: :btree

  create_table "req_workgroups", force: :cascade do |t|
    t.string   "state",        default: "new"
    t.integer  "last_user_id"
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "money"
    t.string   "description"
  end

  add_index "req_workgroups", ["last_user_id"], name: "index_req_workgroups_on_last_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "parent_code"
    t.string   "manager_code"
    t.integer  "level"
    t.integer  "parent_id"
    t.integer  "manager_id"
    t.boolean  "deleted",      default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "units", ["manager_id"], name: "index_units_on_manager_id", using: :btree
  add_index "units", ["parent_id"], name: "index_units_on_parent_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "unit_id"
    t.string   "code"
    t.string   "unit_code"
    t.boolean  "deleted",                default: false
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unit_id"], name: "index_users_on_unit_id", using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users_roles", ["role_id"], name: "index_users_roles_on_role_id", using: :btree
  add_index "users_roles", ["user_id"], name: "index_users_roles_on_user_id", using: :btree

  add_foreign_key "assignments", "users"
  add_foreign_key "histories", "users"
  add_foreign_key "inf_workgroup_members", "req_workgroups"
  add_foreign_key "inf_workgroup_members", "users"
  add_foreign_key "req_reassigns", "clients"
  add_foreign_key "units", "units", column: "parent_id"
  add_foreign_key "units", "users", column: "manager_id"
  add_foreign_key "users", "units"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end
