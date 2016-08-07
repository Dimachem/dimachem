# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersFormulasAssets < ActiveRecord::Migration
  def up
    create_trigger("formulas_assets_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("formulas_assets").
        after(:insert) do
      destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

      <<-SQL_ACTIONS
      thisTrigger: BEGIN
        IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
          LEAVE thisTrigger;
        END IF;

        SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
        SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;

        UPDATE #{destination_db}.new_product_progress_data
        SET `FileName` = NEW.asset_file_name,
            `ContentType` = NEW.asset_content_type,
            `FileSize` = NEW.asset_file_size
        WHERE `Product Code` = @PRODUCT_CODE;
      END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("formulas_assets_after_update_row_tr", :generated => true, :compatibility => 1).
        on("formulas_assets").
        after(:update) do
      destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

      <<-SQL_ACTIONS
      thisTrigger: BEGIN
        IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
          LEAVE thisTrigger;
        END IF;

        SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
        SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;

        UPDATE #{destination_db}.new_product_progress_data
        SET `FileName` = NEW.asset_file_name,
            `ContentType` = NEW.asset_content_type,
            `FileSize` = NEW.asset_file_size
        WHERE `Product Code` = @PRODUCT_CODE;
      END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("formulas_assets_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("formulas_assets").
        after(:delete) do
      destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

      <<-SQL_ACTIONS
      thisTrigger: BEGIN
        IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
          LEAVE thisTrigger;
        END IF;

        SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
        SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

        UPDATE #{destination_db}.new_product_progress_data
        SET `FileName` = NULL,
            `ContentType` = NULL,
            `FileSize` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      END thisTrigger;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("formulas_assets_after_insert_row_tr", "formulas_assets", :generated => true)

    drop_trigger("formulas_assets_after_update_row_tr", "formulas_assets", :generated => true)

    drop_trigger("formulas_assets_after_delete_row_tr", "formulas_assets", :generated => true)
  end
end
