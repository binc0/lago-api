# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# clickhouse:schema:load`. When creating a new database, `rails clickhouse:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ClickhouseActiverecord::Schema.define(version: 2023_10_24_084411) do

  # TABLE: events_raw
  # SQL: CREATE TABLE default.events_raw ( `organization_id` String, `external_customer_id` String, `external_subscription_id` String, `transaction_id` String, `timestamp` DateTime, `code` String, `properties` String ) ENGINE = MergeTree PRIMARY KEY (organization_id, external_subscription_id, code, toStartOfDay(timestamp)) ORDER BY (organization_id, external_subscription_id, code, toStartOfDay(timestamp)) TTL timestamp TO VOLUME 'hot', timestamp + toIntervalDay(90) TO VOLUME 'cold' SETTINGS storage_policy = 'hot_cold', index_granularity = 8192
  create_table "events_raw", id: false, options: "MergeTree PRIMARY KEY (organization_id, external_subscription_id, code, toStartOfDay(timestamp)) ORDER BY (organization_id, external_subscription_id, code, toStartOfDay(timestamp)) TTL timestamp TO VOLUME 'hot', timestamp + toIntervalDay(90) TO VOLUME 'cold' SETTINGS storage_policy = 'hot_cold', index_granularity = 8192", force: :cascade do |t|
    t.string "organization_id", null: false
    t.string "external_customer_id", null: false
    t.string "external_subscription_id", null: false
    t.string "transaction_id", null: false
    t.datetime "timestamp", precision: nil, null: false
    t.string "code", null: false
    t.string "properties", null: false
  end

end
