class Formula < ActiveRecord::Base

  trigger.after(:insert) do
    <<-SQL
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      INSERT INTO chemfil1.new_product_progress_data
        (`Product Code`, `Product Name`, `Status`, `Comments`, `Sales to Date`, `Sr_Mgmt_Rev_BY`)
      VALUES
        (NEW.code, NEW.name, NEW.state, NEW.comments, NEW.sales_to_date, NEW.reviewed_by);
    END thisTrigger
    SQL
  end

  trigger.after(:update) do
    <<-SQL
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
    END thisTrigger
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
    thisTrigger: BEGIN
      IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      DELETE FROM chemfil1.new_product_progress_data
      WHERE `Product Code` = OLD.code;
    END thisTrigger
    SQL
  end

  has_many :Formula_progress_steps

end
