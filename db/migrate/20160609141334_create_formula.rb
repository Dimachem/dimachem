class CreateFormula < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.string :code, null: false
      t.index :code, :unique => true
      t.string :name
      t.string :state
      t.text :comments
      t.decimal :sales_to_date, precision: 19, scale: 4
      t.string :reviewed_by
      t.timestamps null: false
    end
  end
end
