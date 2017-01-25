class CreateFormula < ActiveRecord::Migration
  def change
    create_table :formulas do |t|
      t.string :code, null: false
      t.index :code, :unique => true
      t.string :name
      t.integer :priority
      t.string :state
      t.text :comments
      t.string :reviewed_by
      t.timestamps null: false
    end
  end
end
