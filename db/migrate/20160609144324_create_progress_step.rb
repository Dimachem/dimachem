class CreateProgressStep < ActiveRecord::Migration
  def change
    create_table :progress_steps do |t|
      t.string :code, null: false
      t.index :code, unique: true
      t.string :description, null: false
      t.index :description, unique: true
      t.integer :position, null: false
      t.datetime :effective_on, null: false
      t.datetime :effective_until
      t.timestamps null: false
    end
  end
end
