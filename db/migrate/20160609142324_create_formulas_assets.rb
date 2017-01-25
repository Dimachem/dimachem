class CreateFormulasAssets < ActiveRecord::Migration
  def change
    create_table :formulas_assets do |t|
      t.references :formula, index: true, foreign_key: true
      t.attachment :asset
      t.timestamps null: false
    end
  end
end
