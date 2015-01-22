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

ActiveRecord::Schema.define(version: 20150114145003) do

  create_table "base_drug_hosp", force: :cascade do |t|
    t.string   "drug_name",            limit: 255, null: false
    t.string   "company",              limit: 255
    t.integer  "years",                limit: 4
    t.integer  "sales_sum",            limit: 8
    t.integer  "sales_amount",         limit: 8
    t.string   "specification",        limit: 500
    t.string   "dosage_form",          limit: 100
    t.integer  "quarter",              limit: 4
    t.integer  "per_package",          limit: 4
    t.string   "administration_route", limit: 100
    t.string   "small_class",          limit: 100
    t.string   "big_class",            limit: 100
    t.string   "package_material",     limit: 100
    t.string   "city",                 limit: 100
    t.string   "WHOID",                limit: 20
    t.string   "std_dosage_form",      limit: 100
    t.string   "std_specification",    limit: 500
    t.datetime "update_time"
  end

  add_index "base_drug_hosp", ["city"], name: "city", using: :btree
  add_index "base_drug_hosp", ["company"], name: "company", using: :btree
  add_index "base_drug_hosp", ["dosage_form"], name: "dosage_form", using: :btree
  add_index "base_drug_hosp", ["drug_name"], name: "drug_name", using: :btree
  add_index "base_drug_hosp", ["id"], name: "id", unique: true, using: :btree
  add_index "base_drug_hosp", ["quarter"], name: "quarter", using: :btree
  add_index "base_drug_hosp", ["std_dosage_form"], name: "std_dosage_form", using: :btree
  add_index "base_drug_hosp", ["years"], name: "years", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.integer  "role",                   limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
