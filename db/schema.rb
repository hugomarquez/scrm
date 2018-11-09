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

ActiveRecord::Schema.define(version: 2018_11_07_213112) do

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.integer "trackable_id"
    t.string "owner_type"
    t.integer "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "core_notes", force: :cascade do |t|
    t.string "slug"
    t.boolean "private"
    t.string "title"
    t.text "body"
    t.integer "created_by_id"
    t.string "noteable_type"
    t.integer "noteable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_core_notes_on_created_by_id"
    t.index ["noteable_type", "noteable_id"], name: "index_core_notes_on_noteable_type_and_noteable_id"
  end

  create_table "core_organizations", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "phone"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_core_organizations_on_owner_id"
  end

  create_table "core_people", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "home_phone"
    t.string "other_phone"
    t.string "email"
    t.string "assistant"
    t.string "asst_phone"
    t.string "extension"
    t.string "mobile"
    t.date "birthdate"
    t.string "personable_type"
    t.integer "personable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["personable_type", "personable_id"], name: "index_core_people_on_personable_type_and_personable_id"
  end

  create_table "core_tasks", force: :cascade do |t|
    t.string "slug"
    t.integer "assigned_to_id"
    t.string "taskable_type"
    t.integer "taskable_id"
    t.string "subject"
    t.text "description"
    t.string "location"
    t.string "color"
    t.boolean "all_day"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "status"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_core_tasks_on_assigned_to_id"
    t.index ["taskable_type", "taskable_id"], name: "index_core_tasks_on_taskable_type_and_taskable_id"
  end

  create_table "core_users", force: :cascade do |t|
    t.string "slug"
    t.integer "organization_id"
    t.integer "role", default: 0, null: false
    t.boolean "can_export", default: false, null: false
    t.string "username"
    t.string "company"
    t.string "department"
    t.string "division"
    t.time "start_of_day"
    t.time "end_of_day"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "authentication_token", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_core_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_core_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_core_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_core_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_core_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_core_users_on_invited_by_type_and_invited_by_id"
    t.index ["organization_id"], name: "index_core_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_core_users_on_reset_password_token", unique: true
  end

  create_table "crm_accounts", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "number"
    t.string "phone"
    t.string "extension"
    t.string "email"
    t.string "website"
    t.string "industry"
    t.float "annual_revenue"
    t.integer "rating"
    t.integer "ownership"
    t.integer "priority"
    t.integer "employees"
    t.integer "locations"
    t.string "sic_code"
    t.boolean "active"
    t.string "ticker_symbol"
    t.text "description"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_crm_accounts_on_created_by_id"
  end

  create_table "crm_contacts", force: :cascade do |t|
    t.string "slug"
    t.string "number"
    t.integer "lead_source"
    t.integer "level"
    t.string "language"
    t.text "description"
    t.integer "account_id"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_crm_contacts_on_account_id"
    t.index ["created_by_id"], name: "index_crm_contacts_on_created_by_id"
  end

  create_table "crm_deals", force: :cascade do |t|
    t.string "slug"
    t.string "number"
    t.boolean "private"
    t.string "name"
    t.integer "category"
    t.integer "lead_source"
    t.string "tracking_number"
    t.text "description"
    t.float "amount"
    t.float "expected_revenue"
    t.date "close_at"
    t.string "next_step"
    t.integer "probability"
    t.integer "stage"
    t.string "main_competitor"
    t.string "delivery_status"
    t.integer "account_id"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_crm_deals_on_account_id"
    t.index ["created_by_id"], name: "index_crm_deals_on_created_by_id"
  end

  create_table "crm_leads", force: :cascade do |t|
    t.string "slug"
    t.string "number"
    t.string "source"
    t.string "company"
    t.string "industry"
    t.string "sic_code"
    t.integer "status"
    t.string "website"
    t.integer "rating"
    t.text "description"
    t.integer "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_crm_leads_on_created_by_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

end
