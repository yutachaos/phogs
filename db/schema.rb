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

ActiveRecord::Schema.define(version: 20160507135626) do

  create_table "finds", force: :cascade do |t|
    t.string   "shop_id",        limit: 255
    t.string   "name",           limit: 255
    t.string   "url",            limit: 255
    t.string   "image_url",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "service_remark", limit: 255
    t.integer  "distance",       limit: 4
  end

  create_table "searches", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url",      limit: 255
    t.string   "location",       limit: 255
    t.string   "full_location",  limit: 255
    t.float    "latitude",       limit: 24
    t.float    "longitude",      limit: 24
    t.string   "service_remark", limit: 255
  end

end
