# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersFormulas < ActiveRecord::Migration
  def up
    create_trigger("formulas_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("formulas").
        after(:insert) do
      destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

      <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      INSERT INTO #{destination_db}.new_product_progress_data
        (`Product Code`, `Product Name`, `Priority`, `Status`, `Comments`, `Sr_Mgmt_Rev_BY`)
      VALUES
        (NEW.code, NEW.name, NEW.priority, NEW.state, NEW.comments, NEW.reviewed_by);
    END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("formulas_after_update_row_tr", :generated => true, :compatibility => 1).
        on("formulas").
        after(:update) do
      destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

      <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      UPDATE #{destination_db}.new_product_progress_data
        SET `Product Name` = NEW.name,
            `Priority` = New.priority,
            `Status` = NEW.state,
            `Comments` = NEW.comments,
            `Sr_Mgmt_Rev_BY` = NEW.reviewed_by
      WHERE `Product Code` = OLD.code;
    END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("formulas_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("formulas").
        after(:delete) do
      destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

      <<-SQL_ACTIONS
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      DELETE FROM #{destination_db}.new_product_progress_data
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
