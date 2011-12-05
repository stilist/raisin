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

ActiveRecord::Schema.define(:version => 20111205060213) do

  create_table "entries", :force => true do |t|
    t.string   "title",                             :null => false
    t.text     "body"
    t.string   "bookmark_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",       :default => true
    t.integer  "entry_source_id"
  end

  add_index "entries", ["id"], :name => "index_entries_on_id"

  create_table "entries_keywords", :id => false, :force => true do |t|
    t.integer  "entry_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entries_keywords", ["entry_id", "keyword_id"], :name => "index_entries_keywords_on_entry_id_and_keyword_id"

  create_table "entries_locations", :id => false, :force => true do |t|
    t.integer  "entry_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entry_sources", :force => true do |t|
    t.string   "system_name",  :null => false
    t.string   "display_name", :null => false
    t.string   "homepage",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "keyword_id"
  end

  create_table "keywords", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["id"], :name => "index_keywords_on_id"

  create_table "last_imports", :force => true do |t|
    t.datetime "timestamp"
    t.integer  "entry_source_id"
  end

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.decimal  "lat",           :precision => 15, :scale => 10
    t.decimal  "lng",           :precision => 15, :scale => 10
    t.text     "geoloc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "facebook_id"
    t.string   "foursquare_id"
    t.string   "google_id"
    t.string   "gowalla_id"
    t.string   "yelp_id"
  end

  add_index "locations", ["lat", "lng"], :name => "index_locations_on_lat_and_lng"

end
