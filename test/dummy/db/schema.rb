# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_06_151240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "designation", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["designation"], name: "index_categories_on_designation", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["first_name"], name: "index_clients_on_first_name"
    t.index ["last_name"], name: "index_clients_on_last_name"
  end

  create_table "directories", force: :cascade do |t|
    t.string "name"
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["name"], name: "index_directories_on_name", unique: true
    t.index ["parent_id"], name: "index_directories_on_parent_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "designation", limit: 100
    t.string "description"
    t.decimal "price", precision: 5, scale: 2
    t.float "vat", default: 19.6
    t.boolean "in_stock", default: false
    t.integer "state", default: 0
    t.integer "sub_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["description"], name: "index_products_on_description"
    t.index ["designation"], name: "index_products_on_designation", unique: true
    t.index ["in_stock"], name: "index_products_on_in_stock"
    t.index ["price"], name: "index_products_on_price"
    t.index ["state"], name: "index_products_on_state"
    t.index ["sub_category_id"], name: "index_products_on_sub_category_id"
    t.index ["vat"], name: "index_products_on_vat"
  end

  create_table "sub_categories", force: :cascade do |t|
    t.string "designation"
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.index ["category_id"], name: "index_sub_categories_on_category_id"
    t.index ["designation"], name: "index_sub_categories_on_designation", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "directories", "directories", column: "parent_id"
  add_foreign_key "products", "sub_categories"
  add_foreign_key "sub_categories", "categories"
end
