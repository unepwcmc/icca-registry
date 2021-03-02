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

ActiveRecord::Schema.define(version: 2021_03_01_221411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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

  create_table "comfy_cms_categories", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "categorized_type", null: false
    t.index ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true
  end

  create_table "comfy_cms_categorizations", id: :serial, force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "categorized_type", null: false
    t.integer "categorized_id", null: false
    t.index ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true
  end

  create_table "comfy_cms_files", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "block_id"
    t.string "label", default: "", null: false
    t.string "file_file_name"
    t.string "description", limit: 2048
    t.integer "position", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id"
    t.index ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name"
    t.index ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label"
    t.index ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position"
  end

  create_table "comfy_cms_fragments", id: :serial, force: :cascade do |t|
    t.string "identifier", null: false
    t.text "content"
    t.integer "record_id"
    t.string "record_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "tag", default: "text", null: false
    t.datetime "datetime"
    t.boolean "boolean", default: false, null: false
    t.index ["identifier"], name: "index_comfy_cms_fragments_on_identifier"
    t.index ["record_id", "record_type"], name: "index_comfy_cms_fragments_on_record_id_and_record_type"
  end

  create_table "comfy_cms_layouts", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "parent_id"
    t.string "app_layout"
    t.string "label", null: false
    t.string "identifier", null: false
    t.text "content"
    t.text "css"
    t.text "js"
    t.integer "position", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position"
    t.index ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true
  end

  create_table "comfy_cms_pages", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "layout_id"
    t.integer "parent_id"
    t.integer "target_page_id"
    t.string "label", null: false
    t.string "slug"
    t.string "full_path", null: false
    t.text "content_cache"
    t.integer "position", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.boolean "is_published", default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "country_id"
    t.integer "icca_site_id"
    t.index ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position"
    t.index ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path"
  end

  create_table "comfy_cms_revisions", id: :serial, force: :cascade do |t|
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.index ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at"
  end

  create_table "comfy_cms_sites", id: :serial, force: :cascade do |t|
    t.string "label", null: false
    t.string "identifier", null: false
    t.string "hostname", null: false
    t.string "path"
    t.string "locale", default: "en", null: false
    t.index ["hostname"], name: "index_comfy_cms_sites_on_hostname"
  end

  create_table "comfy_cms_snippets", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "identifier", null: false
    t.text "content"
    t.integer "position", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true
    t.index ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position"
  end

  create_table "comfy_cms_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.integer "page_id", null: false
    t.integer "layout_id"
    t.string "label", null: false
    t.text "content_cache"
    t.boolean "is_published", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_published"], name: "index_comfy_cms_translations_on_is_published"
    t.index ["locale"], name: "index_comfy_cms_translations_on_locale"
    t.index ["page_id"], name: "index_comfy_cms_translations_on_page_id"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "lat"
    t.string "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "iso_3"
    t.text "description"
  end

  create_table "icca_sites", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "lon", precision: 5, scale: 2
    t.decimal "lat", precision: 5, scale: 2
  end

  create_table "interest_submissions", id: :serial, force: :cascade do |t|
    t.text "icca_name"
    t.text "country"
    t.text "icca_size"
    t.text "email"
    t.boolean "can_contact"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "searchable_id"
    t.string "searchable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "related_links", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.string "label"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.string "label"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
