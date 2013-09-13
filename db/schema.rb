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

ActiveRecord::Schema.define(version: 20130913181356) do

  create_table "accounts", force: true do |t|
    t.string   "accountable_type",                 null: false
    t.string   "name"
    t.string   "website"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "address"
    t.text     "notes"
    t.integer  "country_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps",            default: true
    t.boolean  "enabled",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified",         default: false
    t.integer  "logo_resource_id"
    t.string   "city",             default: ""
    t.string   "zipcode",          default: ""
    t.integer  "state_id"
  end

  add_index "accounts", ["country_id"], name: "index_accounts_on_country_id", using: :btree

  create_table "agency_contracts", force: true do |t|
    t.integer  "agency_id"
    t.text     "content"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agency_contracts", ["agency_id"], name: "index_agency_contracts_on_agency_id", using: :btree

  create_table "agency_services", force: true do |t|
    t.integer  "agency_id"
    t.integer  "debt_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debt_segment_id"
  end

  add_index "agency_services", ["agency_id", "debt_type_id", "debt_segment_id"], name: "agency_debt_type_debt_segment", unique: true, using: :btree

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "initials"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debt_files", force: true do |t|
    t.integer  "debt_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debt_files", ["debt_id"], name: "index_debt_files_on_debt_id", using: :btree
  add_index "debt_files", ["resource_id"], name: "index_debt_files_on_resource_id", using: :btree

  create_table "debt_payments", force: true do |t|
    t.integer  "debt_placement_id"
    t.integer  "debt_id"
    t.date     "payment_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount_cents",      default: 0,     null: false
    t.string   "amount_currency",   default: "USD", null: false
  end

  add_index "debt_payments", ["debt_id"], name: "index_debt_payments_on_debt_id", using: :btree
  add_index "debt_payments", ["debt_placement_id"], name: "index_debt_payments_on_debt_placement_id", using: :btree

  create_table "debt_placements", force: true do |t|
    t.integer  "debt_id"
    t.integer  "agency_id"
    t.integer  "price_model_id"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agency_contract_id"
    t.datetime "accepted_at"
    t.datetime "resolved_at"
  end

  add_index "debt_placements", ["agency_contract_id"], name: "index_debt_placements_on_agency_contract_id", using: :btree
  add_index "debt_placements", ["agency_id"], name: "index_debt_placements_on_agency_id", using: :btree
  add_index "debt_placements", ["debt_id"], name: "index_debt_placements_on_debt_id", using: :btree
  add_index "debt_placements", ["price_model_id"], name: "index_debt_placements_on_price_model_id", using: :btree

  create_table "debt_segments", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debt_shoppinglist_item_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debt_shoppinglist_items", force: true do |t|
    t.integer  "account_id"
    t.integer  "debt_id"
    t.integer  "agency_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shoppinglist_item_status_id"
  end

  add_index "debt_shoppinglist_items", ["account_id"], name: "index_debt_shoppinglist_items_on_account_id", using: :btree
  add_index "debt_shoppinglist_items", ["debt_id"], name: "index_debt_shoppinglist_items_on_debt_id", using: :btree

  create_table "debt_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debt_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debts", force: true do |t|
    t.string   "title"
    t.string   "address"
    t.integer  "debt_type_id"
    t.date     "charge_date"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "debt_segment_id"
    t.boolean  "gmaps",                default: true
    t.integer  "country_id"
    t.integer  "account_id"
    t.integer  "debt_status_id"
    t.boolean  "deleted",              default: false
    t.string   "city",                 default: ""
    t.string   "zipcode",              default: ""
    t.integer  "state_id"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.integer  "amount_cents",         default: 0,     null: false
    t.string   "amount_currency",      default: "USD", null: false
    t.integer  "amount_paid_cents",    default: 0,     null: false
    t.string   "amount_paid_currency", default: "USD", null: false
  end

  add_index "debts", ["account_id"], name: "index_debts_on_account_id", using: :btree

  create_table "event_files", force: true do |t|
    t.integer  "event_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_files", ["event_id"], name: "index_event_files_on_event_id", using: :btree
  add_index "event_files", ["resource_id"], name: "index_event_files_on_resource_id", using: :btree

  create_table "event_types", force: true do |t|
    t.string "name"
  end

  create_table "events", force: true do |t|
    t.integer  "event_type"
    t.integer  "user_id"
    t.integer  "account_id"
    t.text     "text"
    t.integer  "entity_id"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entity_type"
  end

  add_index "events", ["account_id"], name: "index_events_on_account_id", using: :btree
  add_index "events", ["entity_id", "created_at"], name: "index_events_on_entity_type_and_entity_id_and_created_at", using: :btree

  create_table "price_models", force: true do |t|
    t.string   "name"
    t.integer  "agency_id"
    t.integer  "min_age"
    t.integer  "max_age"
    t.float    "fee_precentage"
    t.text     "description"
    t.boolean  "enabled"
    t.boolean  "system",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_amount_cents",    default: 0,     null: false
    t.string   "min_amount_currency", default: "USD", null: false
    t.integer  "max_amount_cents",    default: 0,     null: false
    t.string   "max_amount_currency", default: "USD", null: false
  end

  add_index "price_models", ["agency_id"], name: "index_price_models_on_agency_id", using: :btree

  create_table "price_models_debt_types", id: false, force: true do |t|
    t.integer "price_model_id", null: false
    t.integer "debt_type_id",   null: false
  end

  add_index "price_models_debt_types", ["debt_type_id"], name: "index_price_models_debt_types_on_debt_type_id", using: :btree
  add_index "price_models_debt_types", ["price_model_id", "debt_type_id"], name: "price_models_debt_types_index", unique: true, using: :btree

  create_table "resources", force: true do |t|
    t.integer  "account_id"
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
  end

  add_index "resources", ["account_id"], name: "index_resources_on_account_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "agency_id",         null: false
    t.integer  "review_level"
    t.integer  "service_level"
    t.integer  "aggresive_level"
    t.integer  "speed_level"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",           null: false
    t.integer  "debt_placement_id"
  end

  add_index "reviews", ["agency_id", "debt_placement_id"], name: "index_reviews_on_agency_id_and_debt_placement_id", unique: true, using: :btree
  add_index "reviews", ["debt_placement_id"], name: "index_reviews_on_debt_placement_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "initials"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "remember_token"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "account_id",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask",             default: 0
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
