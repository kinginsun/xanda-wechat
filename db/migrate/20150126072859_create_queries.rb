class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text :statement
      t.string :open_id
      t.string :email
      t.integer :rows
      t.datetime :paid_at
      t.integer :total_fee
      t.text :post_raw_data

      t.timestamps null: false
    end
  end
end
