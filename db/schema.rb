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

ActiveRecord::Schema.define(version: 20170223023246) do

  create_table "invoices", force: :cascade do |t|
    t.string  "uuid",       limit: 36
    t.integer "order_id"
    t.integer "payment_id"
    t.index ["order_id"], name: "index_invoices_on_order_id"
    t.index ["payment_id"], name: "index_invoices_on_payment_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "style"
    t.string   "strength"
    t.integer  "quantity",   limit: 2
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string   "number",     limit: 19
    t.date     "expiry"
    t.string   "cvv",        limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
