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

ActiveRecord::Schema.define(version: 20160924191927) do

  create_table "admin_credentials", force: :cascade do |t|
    t.string   "account"
    t.string   "encrypted_password"
    t.string   "encrypted_password_iv"
    t.string   "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["description"], name: "index_admin_credentials_on_description", unique: true
  end

  create_table "admin_resources", force: :cascade do |t|
    t.string   "address"
    t.string   "protocol"
    t.integer  "credential_id"
    t.integer  "bears_instance_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "bears_instances", force: :cascade do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_bears_instances_on_name", unique: true
  end

  create_table "data_centers", force: :cascade do |t|
    t.string   "name"
    t.string   "dc_code",           limit: 8
    t.integer  "bears_instance_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["dc_code"], name: "index_data_centers_on_dc_code", unique: true
  end

  create_table "resource_storage_a3_par_arrays", force: :cascade do |t|
    t.string   "name"
    t.string   "model"
    t.string   "serial"
    t.string   "firmware"
    t.integer  "space_total"
    t.integer  "space_available"
    t.integer  "space_used"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "data_center_id"
    t.index ["data_center_id"], name: "index_resource_storage_a3_par_arrays_on_data_center_id"
    t.index ["name"], name: "index_resource_storage_a3_par_arrays_on_name"
    t.index ["serial"], name: "index_resource_storage_a3_par_arrays_on_serial", unique: true
  end

  create_table "resource_storage_arrays", force: :cascade do |t|
    t.integer  "instance_id"
    t.string   "instance_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "data_center_id"
    t.index ["data_center_id"], name: "index_resource_storage_arrays_on_data_center_id"
    t.index ["instance_id", "instance_type"], name: "index_resource_storage_arrays_on_instance_id_and_instance_type"
  end

  create_table "resource_storage_eva_arrays", force: :cascade do |t|
    t.string   "name"
    t.string   "model"
    t.string   "serial"
    t.string   "firmware"
    t.integer  "space_total"
    t.integer  "space_available"
    t.integer  "space_used"
    t.integer  "data_center_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["data_center_id"], name: "index_resource_storage_eva_arrays_on_data_center_id"
    t.index ["name"], name: "index_resource_storage_eva_arrays_on_name"
    t.index ["serial"], name: "index_resource_storage_eva_arrays_on_serial", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "login"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "roles",           limit: 2, default: "U"
    t.index ["login"], name: "index_users_on_login", unique: true
  end

end
