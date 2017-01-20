class ChangeFormulasAddStartDate < ActiveRecord::Migration
  def change
    change_table :formulas do |t|
      t.datetime :start_date
      t.string :requested_by
      t.string :customer
    end
  end
end
