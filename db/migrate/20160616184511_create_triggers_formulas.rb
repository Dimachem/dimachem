# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersFormulas < ActiveRecord::Migration
  def up
    create_trigger("formulas_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("formulas").
        after(:insert) do
      <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      INSERT INTO chemfil1.new_product_progress_data
        (`Product Code`, `Product Name`, `Status`, `Comments`, `Sales to Date`, `Sr_Mgmt_Rev_BY`)
      VALUES
        (NEW.code, NEW.name, NEW.state, NEW.comments, NEW.sales_to_date, NEW.reviewed_by);
    END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("formulas_after_update_row_tr", :generated => true, :compatibility => 1).
        on("formulas").
        after(:update) do
      <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      UPDATE chemfil1.new_product_progress_data
        SET `Product Name` = NEW.name,
            `Status` = NEW.state,
            `Comments` = NEW.comments,
            `Sales to Date` = NEW.sales_to_date,
            `Sr_Mgmt_Rev_BY` = NEW.reviewed_by
      WHERE `Product Code` = OLD.code;
    END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("formulas_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("formulas").
        after(:delete) do
      <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      DELETE FROM chemfil1.new_product_progress_data
      WHERE `Product Code` = OLD.code;
    END thisTrigger;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("formulas_after_insert_row_tr", "formulas", :generated => true)

    drop_trigger("formulas_after_update_row_tr", "formulas", :generated => true)

    drop_trigger("formulas_after_delete_row_tr", "formulas", :generated => true)
  end
end
