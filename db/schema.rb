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

ActiveRecord::Schema.define(version: 20170918173224) do

  create_table "admins", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password"
    t.integer  "issuper"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cars", force: :cascade do |t|
    t.string   "model"
    t.string   "style"
    t.integer  "licencePlateNumber"
    t.string   "location"
    t.integer  "status"
    t.float    "hourlyRentalRate"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "manufacturer"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer  "status"
    t.datetime "endTime"
    t.integer  "customer_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "car_id"
    t.datetime "reserved_time"
    t.datetime "checkout_time"
    t.datetime "end_time"
    t.float    "rental_charge"
  end

end
