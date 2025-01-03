# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_12_25_222327) do
  create_table "reports", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "similarities_scaled_score"
    t.integer "similarities_percentile_score"
    t.integer "vocabulary_scaled_score"
    t.integer "vocabulary_percentile_score"
    t.integer "block_design_scaled_score"
    t.integer "block_design_percentile_score"
    t.integer "visual_puzzles_scaled_score"
    t.integer "visual_puzzles_percentile_score"
    t.integer "matrix_reasoning_scaled_score"
    t.integer "matrix_reasoning_percentile_score"
    t.integer "figure_weights_scaled_score"
    t.integer "figure_weights_percentile_score"
    t.integer "digit_span_scaled_score"
    t.integer "digit_span_percentile_score"
    t.integer "picture_span_scaled_score"
    t.integer "picture_span_percentile_score"
    t.integer "coding_scaled_score"
    t.integer "coding_percentile_score"
    t.integer "symbol_search_scaled_score"
    t.integer "symbol_search_percentile_score"
    t.text "analysis"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "vci_standard"
    t.integer "vci_percentile"
    t.text "vci_analysis"
    t.integer "vsi_standard"
    t.integer "vsi_percentile"
    t.text "vsi_analysis"
    t.integer "fri_standard"
    t.integer "fri_percentile"
    t.text "fri_analysis"
    t.integer "wmi_standard"
    t.integer "wmi_percentile"
    t.text "wmi_analysis"
    t.integer "psi_standard"
    t.integer "psi_percentile"
    t.text "psi_analysis"
    t.integer "fsiq_standard"
    t.integer "fsiq_percentile"
    t.text "fsiq_analysis"
    t.text "similarities_analysis"
    t.text "vocabulary_analysis"
    t.text "block_design_analysis"
    t.text "visual_puzzles_analysis"
    t.text "matrix_reasoning_analysis"
    t.text "figure_weights_analysis"
    t.text "digit_span_analysis"
    t.text "picture_span_analysis"
    t.text "symbol_search_analysis"
    t.text "coding_analysis"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "reports", "users"
end
