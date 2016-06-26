class FormulasProgressStep < ActiveRecord::Base

  trigger.after(:insert) do
    <<-SQL
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = NEW.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Cust_Req_Com` = NEW.comments,
              `Cust_Req_YN` = NEW.completed,
              `Cust_Req_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Cust_Specs_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Cust_Specs_Com` = NEW.comments,
              `Cust_Specs_YN` = NEW.completed,
              `Cust_Specs_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "TDS MSDS " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `TDS MSDS Com` = NEW.comments,
              `TDS MSDS YN` = NEW.completed,
              `TDS MSDS Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Formula " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Formula Com` = NEW.comments,
              `Formula YN` = NEW.completed,
              `Formula Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Disc Nature-Duration-Complexity Com` = NEW.comments,
              `Disc Nature-Duration-Complexity YN` = NEW.completed,
              `Disc Nature-Duration-Complexity Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Disc Consequences of Failure Com` = NEW.comments,
              `Disc Consequences of Failure YN` = NEW.completed,
              `Disc Consequences of Failure Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Test Proc Rec " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Test Proc Rec Com` = NEW.comments,
              `Test Proc Rec YN` = NEW.completed,
              `Test Proc Rec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Prod Spec " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Prod Spec Com` = NEW.comments,
              `Prod Spec YN` = NEW.completed,
              `Prod Spec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "OK on Raws " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `OK on Raws Com` = NEW.comments,
              `OK on Raws YN` = NEW.completed,
              `OK on Raws Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Prod Code Entered " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Prod Code Entered Com` = NEW.comments,
              `Prod Code Entered YN` = NEW.completed,
              `Prod Code Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "MSDS Init " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `MSDS Init Com` = NEW.comments,
              `MSDS Init YN` = NEW.completed,
              `MSDS Init Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Lab Batch " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Lab Batch Com` = NEW.comments,
              `Lab Batch YN` = NEW.completed,
              `Lab Batch Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "QC Tests Entered " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `QC Tests Entered Com` = NEW.comments,
              `QC Tests Entered YN` = NEW.completed,
              `QC Tests Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Formula Entered " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Formula Entered Com` = NEW.comments,
              `Formula Entered YN` = NEW.completed,
              `Formula Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "MOC " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `MOC Com` = NEW.comments,
              `MOC YN` = NEW.completed,
              `MOC Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Env_Aspects_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Env_Aspects_Com` = NEW.comments,
              `Env_Aspects_YN` = NEW.completed,
              `Env_Aspects_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NEW.comments,
              `Sr_Mgmt_Rev_YN` = NEW.completed,
              `Sr_Mgmt_Rev_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Form to Purch Mang " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Form to Purch Mang Com` = NEW.comments,
              `Form to Purch Mang YN` = NEW.completed,
              `Form to Purch Mang Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Test proc Forw " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Test proc Forw Com` = NEW.comments,
              `Test proc Forw YN` = NEW.completed,
              `Test proc Forw Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      END IF;

    END thisTrigger
    SQL
  end

  trigger.after(:update) do
    <<-SQL
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Cust_Req_Com` = NEW.comments,
              `Cust_Req_YN` = NEW.completed,
              `Cust_Req_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Cust_Specs_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Cust_Specs_Com` = NEW.comments,
              `Cust_Specs_YN` = NEW.completed,
              `Cust_Specs_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "TDS MSDS " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `TDS MSDS Com` = NEW.comments,
              `TDS MSDS YN` = NEW.completed,
              `TDS MSDS Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Formula " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Formula Com` = NEW.comments,
              `Formula YN` = NEW.completed,
              `Formula Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Disc Nature-Duration-Complexity Com` = NEW.comments,
              `Disc Nature-Duration-Complexity YN` = NEW.completed,
              `Disc Nature-Duration-Complexity Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Disc Consequences of Failure Com` = NEW.comments,
              `Disc Consequences of Failure YN` = NEW.completed,
              `Disc Consequences of Failure Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Test Proc Rec " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Test Proc Rec Com` = NEW.comments,
              `Test Proc Rec YN` = NEW.completed,
              `Test Proc Rec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Prod Spec " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Prod Spec Com` = NEW.comments,
              `Prod Spec YN` = NEW.completed,
              `Prod Spec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "OK on Raws " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `OK on Raws Com` = NEW.comments,
              `OK on Raws YN` = NEW.completed,
              `OK on Raws Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Prod Code Entered " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Prod Code Entered Com` = NEW.comments,
              `Prod Code Entered YN` = NEW.completed,
              `Prod Code Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "MSDS Init " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `MSDS Init Com` = NEW.comments,
              `MSDS Init YN` = NEW.completed,
              `MSDS Init Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Lab Batch " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Lab Batch Com` = NEW.comments,
              `Lab Batch YN` = NEW.completed,
              `Lab Batch Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "QC Tests Entered " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `QC Tests Entered Com` = NEW.comments,
              `QC Tests Entered YN` = NEW.completed,
              `QC Tests Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Formula Entered " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Formula Entered Com` = NEW.comments,
              `Formula Entered YN` = NEW.completed,
              `Formula Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "MOC " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `MOC Com` = NEW.comments,
              `MOC YN` = NEW.completed,
              `MOC Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Env_Aspects_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Env_Aspects_Com` = NEW.comments,
              `Env_Aspects_YN` = NEW.completed,
              `Env_Aspects_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev_" THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NEW.comments,
              `Sr_Mgmt_Rev_YN` = NEW.completed,
              `Sr_Mgmt_Rev_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Form to Purch Mang " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Form to Purch Mang Com` = NEW.comments,
              `Form to Purch Mang YN` = NEW.completed,
              `Form to Purch Mang Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Test proc Forw " THEN
        UPDATE chemfil1.new_product_progress_data
          SET `Test proc Forw Com` = NEW.comments,
              `Test proc Forw YN` = NEW.completed,
              `Test proc Forw Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      END IF;

    END thisTrigger
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req_" THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Cust_Req_Com` = OLD.comments,
              `Cust_Req_YN` = OLD.completed,
              `Cust_Req_Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Cust_Specs_" THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Cust_Specs_Com` = OLD.comments,
              `Cust_Specs_YN` = OLD.completed,
              `Cust_Specs_Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "TDS MSDS " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `TDS MSDS Com` = OLD.comments,
              `TDS MSDS YN` = OLD.completed,
              `TDS MSDS Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Formula " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Formula Com` = OLD.comments,
              `Formula YN` = OLD.completed,
              `Formula Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Disc Nature-Duration-Complexity Com` = OLD.comments,
              `Disc Nature-Duration-Complexity YN` = OLD.completed,
              `Disc Nature-Duration-Complexity Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Disc Consequences of Failure Com` = OLD.comments,
              `Disc Consequences of Failure YN` = OLD.completed,
              `Disc Consequences of Failure Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Test Proc Rec " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Test Proc Rec Com` = OLD.comments,
              `Test Proc Rec YN` = OLD.completed,
              `Test Proc Rec Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Prod Spec " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Prod Spec Com` = OLD.comments,
              `Prod Spec YN` = OLD.completed,
              `Prod Spec Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "OK on Raws " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `OK on Raws Com` = OLD.comments,
              `OK on Raws YN` = OLD.completed,
              `OK on Raws Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Prod Code Entered " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Prod Code Entered Com` = OLD.comments,
              `Prod Code Entered YN` = OLD.completed,
              `Prod Code Entered Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "MSDS Init " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `MSDS Init Com` = OLD.comments,
              `MSDS Init YN` = OLD.completed,
              `MSDS Init Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Lab Batch " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Lab Batch Com` = OLD.comments,
              `Lab Batch YN` = OLD.completed,
              `Lab Batch Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "QC Tests Entered " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `QC Tests Entered Com` = OLD.comments,
              `QC Tests Entered YN` = OLD.completed,
              `QC Tests Entered Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Formula Entered " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Formula Entered Com` = OLD.comments,
              `Formula Entered YN` = OLD.completed,
              `Formula Entered Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "MOC " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `MOC Com` = OLD.comments,
              `MOC YN` = OLD.completed,
              `MOC Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Env_Aspects_" THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Env_Aspects_Com` = OLD.comments,
              `Env_Aspects_YN` = OLD.completed,
              `Env_Aspects_Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev_" THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = OLD.comments,
              `Sr_Mgmt_Rev_YN` = OLD.completed,
              `Sr_Mgmt_Rev_Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Form to Purch Mang " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Form to Purch Mang Com` = OLD.comments,
              `Form to Purch Mang YN` = OLD.completed,
              `Form to Purch Mang Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      ELSEIF @STEP_CODE = "Test proc Forw " THEN
        UPDATE chemfil1.OLD_product_progress_data
          SET `Test proc Forw Com` = OLD.comments,
              `Test proc Forw YN` = OLD.completed,
              `Test proc Forw Date` = OLD.completed_on
        WHERE `Product Code` = @PRODUCT_CODE COLLATE utf8_unicode_ci;
      END IF;

    END thisTrigger
    SQL
  end

  belongs_to :formula
  belongs_to :progress_step

end
