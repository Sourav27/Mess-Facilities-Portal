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

ActiveRecord::Schema.define(version: 20170205063848) do

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "password_digest", null: false
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                           null: false
    t.string  "type_name",                      null: false
    t.integer "type_id",                        null: false
    t.text    "member_relation",  limit: 65535, null: false
    t.text    "vendors_relation", limit: 65535, null: false
  end

  create_table "categories1", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name",                           null: false
    t.string  "type_name",                      null: false
    t.integer "type_id",                        null: false
    t.text    "member_relation",  limit: 65535, null: false
    t.text    "vendors_relation", limit: 65535, null: false
  end

  create_table "complaint_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
  end

  create_table "complaints", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user_id",                                               null: false
    t.string   "title",                                                 null: false
    t.text     "content",                limit: 65535,                  null: false
    t.integer  "category_id",                                           null: false
    t.boolean  "solved",                               default: false,  null: false
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.string   "relation",                                              null: false
    t.string   "resolved_by",                          default: "null"
    t.string   "complaint_category_ids"
    t.boolean  "contacted",                            default: false
    t.index ["category_id"], name: "index_complaints_on_category_id", using: :btree
    t.index ["user_id"], name: "index_complaints_on_user_id", using: :btree
  end

  create_table "members", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username",   null: false
    t.string "name",       null: false
    t.string "email",      null: false
    t.string "mobile",     null: false
    t.string "categories", null: false
    t.string "position"
  end

  create_table "members1", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username",   null: false
    t.string "name",       null: false
    t.string "email",      null: false
    t.string "mobile",     null: false
    t.string "categories", null: false
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "body",       limit: 65535
    t.string   "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "relation",                 null: false
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user",       null: false
    t.datetime "time",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.bigint   "id",                                                                null: false, unsigned: true
    t.text     "fcmtoken",       limit: 65535,                                      null: false
    t.text     "student_name",   limit: 65535,                                      null: false
    t.text     "student_rollno", limit: 65535,                                      null: false
    t.datetime "last_used",                    default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["id"], name: "id", unique: true, using: :btree
  end

  create_table "vendors", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "category_id"
    t.string  "name"
    t.string  "email"
    t.integer "mobile"
    t.index ["category_id"], name: "category_id", unique: true, using: :btree
  end

  create_table "vendors1", primary_key: "category_id", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name",   null: false
    t.string "email",  null: false
    t.string "mobile", null: false
  end

  create_table "vendors_details", id: :bigint, unsigned: true, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.text "facility",     limit: 65535, collation: "utf8_general_ci"
    t.text "email_id",     limit: 65535, collation: "utf8_general_ci"
    t.text "phone_number", limit: 65535, collation: "utf8_general_ci"
    t.index ["id"], name: "id", unique: true, using: :btree
  end

end
