class CreateBaseDrugHosps < ActiveRecord::Migration
  def change
    create_table "base_drug_hosp", force: :cascade do |t|
      t.string   "drug_name",            limit: 255, null: false
      t.string   "company",              limit: 255
      t.integer  "years",                limit: 4
      t.integer  "sales_sum",            limit: 8
      t.integer  "sales_amount",         limit: 8
      t.string   "specification",        limit: 500
      t.string   "dosage_form",          limit: 100
      t.integer  "quarter",              limit: 4
      t.integer  "per_package",          limit: 4
      t.string   "administration_route", limit: 100
      t.string   "small_class",          limit: 100
      t.string   "big_class",            limit: 100
      t.string   "package_material",     limit: 100
      t.string   "city",                 limit: 100
      t.string   "WHOID",                limit: 20
      t.string   "std_dosage_form",      limit: 100
      t.string   "std_specification",    limit: 500
      t.datetime "update_time"
    end

    add_index "base_drug_hosp", ["city"], name: "city", using: :btree
    add_index "base_drug_hosp", ["company"], name: "company", using: :btree
    add_index "base_drug_hosp", ["dosage_form"], name: "dosage_form", using: :btree
    add_index "base_drug_hosp", ["drug_name"], name: "drug_name", using: :btree
    add_index "base_drug_hosp", ["id"], name: "id", unique: true, using: :btree
    add_index "base_drug_hosp", ["quarter"], name: "quarter", using: :btree
    add_index "base_drug_hosp", ["std_dosage_form"], name: "std_dosage_form", using: :btree
    # add_index "base_drug_hosp", ["std_specification"], name: "std_specification", using: :btree
    add_index "base_drug_hosp", ["years"], name: "years", using: :btree
  end
end
