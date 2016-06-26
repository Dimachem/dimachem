class CreateJoinTableFormulasProgressStep < ActiveRecord::Migration
  def change
    create_join_table :formulas, :progress_steps do |t|
      t.index [:formula_id, :progress_step_id], unique: true
      t.references :formula, index: true, foreign_key: true
      t.references :progress_step, index: true, foreign_key: true
      t.boolean :completed, default: false, null: false
      t.datetime :completed_on
      t.string :comments
      t.timestamps null: false
    end
  end
end
