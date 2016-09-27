class FormulasProgressStep < ActiveRecord::Base
  belongs_to :formula
  belongs_to :progress_step

  trigger.after(:insert) do
    destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

    <<-SQL
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = NEW.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Cust_Req_Com` = NEW.comments,
              `Cust_Req_YN` = NEW.completed,
              `Cust_Req_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Cust_Specs" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Cust_Specs_Com` = NEW.comments,
              `Cust_Specs_YN` = NEW.completed,
              `Cust_Specs_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "TDS MSDS" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `TDS MSDS Com` = NEW.comments,
              `TDS MSDS YN` = NEW.completed,
              `TDS MSDS Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Formula Com` = NEW.comments,
              `Formula YN` = NEW.completed,
              `Formula Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Disc Nature-Duration-Complexity` = NEW.comments,
              `Disc Nature-Duration-Complexity YN` = NEW.completed,
              `Disc Nature-Duration-Complexity Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Disc Consequences of Failure` = NEW.comments,
              `Disc Consequences of Failure YN` = NEW.completed,
              `Disc Consequences of Failure Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test Proc Rec" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Test Proc Rec Com` = NEW.comments,
              `Test Proc Rec YN` = NEW.completed,
              `Test Proc Rec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Spec" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Prod Spec Com` = NEW.comments,
              `Prod Spec YN` = NEW.completed,
              `Prod Spec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "OK on Raws" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `OK on Raws Com` = NEW.comments,
              `OK on Raws YN` = NEW.completed,
              `OK on Raws Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Code Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Prod Code Entered Com` = NEW.comments,
              `Prod Code Entered YN` = NEW.completed,
              `Prod Code Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MSDS Init" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `MSDS Init Com` = NEW.comments,
              `MSDS Init YN` = NEW.completed,
              `MSDS Init Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Lab Batch" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Lab Batch Com` = NEW.comments,
              `Lab Batch YN` = NEW.completed,
              `Lab Batch Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "QC Tests Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `QC Tests Entered Com` = NEW.comments,
              `QC Tests Entered YN` = NEW.completed,
              `QC Tests Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Formula Entered Com` = NEW.comments,
              `Formula Entered YN` = NEW.completed,
              `Formula Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MOC" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `MOC_Com` = NEW.comments,
              `MOC_YN` = NEW.completed,
              `MOC_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Env_Aspects" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Env_Aspects_Com` = NEW.comments,
              `Env_Aspects_YN` = NEW.completed,
              `Env_Aspects_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NEW.comments,
              `Sr_Mgmt_Rev_YN` = NEW.completed,
              `Sr_Mgmt_Rev_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Form to Purch Mang Com` = NEW.comments,
              `Form to Purch Mang YN` = NEW.completed,
              `Form to Purch Mang Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test proc Forw" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Test proc Forw Com` = NEW.comments,
              `Test proc Forw YN` = NEW.completed,
              `Test proc Forw Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      END IF;

    END thisTrigger
    SQL
  end

  trigger.after(:update) do
    destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

    <<-SQL
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Cust_Req_Com` = NEW.comments,
              `Cust_Req_YN` = NEW.completed,
              `Cust_Req_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Cust_Specs" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Cust_Specs_Com` = NEW.comments,
              `Cust_Specs_YN` = NEW.completed,
              `Cust_Specs_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "TDS MSDS" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `TDS MSDS Com` = NEW.comments,
              `TDS MSDS YN` = NEW.completed,
              `TDS MSDS Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Formula Com` = NEW.comments,
              `Formula YN` = NEW.completed,
              `Formula Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Disc Nature-Duration-Complexity` = NEW.comments,
              `Disc Nature-Duration-Complexity YN` = NEW.completed,
              `Disc Nature-Duration-Complexity Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Disc Consequences of Failure` = NEW.comments,
              `Disc Consequences of Failure YN` = NEW.completed,
              `Disc Consequences of Failure Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test Proc Rec" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Test Proc Rec Com` = NEW.comments,
              `Test Proc Rec YN` = NEW.completed,
              `Test Proc Rec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Spec" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Prod Spec Com` = NEW.comments,
              `Prod Spec YN` = NEW.completed,
              `Prod Spec Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "OK on Raws" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `OK on Raws Com` = NEW.comments,
              `OK on Raws YN` = NEW.completed,
              `OK on Raws Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Code Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Prod Code Entered Com` = NEW.comments,
              `Prod Code Entered YN` = NEW.completed,
              `Prod Code Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MSDS Init" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `MSDS Init Com` = NEW.comments,
              `MSDS Init YN` = NEW.completed,
              `MSDS Init Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Lab Batch" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Lab Batch Com` = NEW.comments,
              `Lab Batch YN` = NEW.completed,
              `Lab Batch Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "QC Tests Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `QC Tests Entered Com` = NEW.comments,
              `QC Tests Entered YN` = NEW.completed,
              `QC Tests Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Formula Entered Com` = NEW.comments,
              `Formula Entered YN` = NEW.completed,
              `Formula Entered Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MOC" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `MOC_Com` = NEW.comments,
              `MOC_YN` = NEW.completed,
              `MOC_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Env_Aspects" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Env_Aspects_Com` = NEW.comments,
              `Env_Aspects_YN` = NEW.completed,
              `Env_Aspects_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NEW.comments,
              `Sr_Mgmt_Rev_YN` = NEW.completed,
              `Sr_Mgmt_Rev_Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Form to Purch Mang Com` = NEW.comments,
              `Form to Purch Mang YN` = NEW.completed,
              `Form to Purch Mang Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test proc Forw" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Test proc Forw Com` = NEW.comments,
              `Test proc Forw YN` = NEW.completed,
              `Test proc Forw Date` = NEW.completed_on
        WHERE `Product Code` = @PRODUCT_CODE;
      END IF;

    END thisTrigger
    SQL
  end

  trigger.after(:delete) do
    destination_db = Rails.application.config.database_configuration()["#{Rails.env}_sync"]['database']

    <<-SQL
    thisTrigger: BEGIN
      IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
        LEAVE thisTrigger;
      END IF;

      SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
      SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
      SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;

      IF @STEP_CODE = "Cust_Req" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Cust_Req_Com` = NULL,
              `Cust_Req_YN` = 0,
              `Cust_Req_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Cust_Specs" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Cust_Specs_Com` = NULL,
              `Cust_Specs_YN` = 0,
              `Cust_Specs_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "TDS MSDS" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `TDS MSDS Com` = NULL,
              `TDS MSDS YN` = 0,
              `TDS MSDS Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Formula Com` = NULL,
              `Formula YN` = 0,
              `Formula Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Disc Nature-Duration-Complexity` = NULL,
              `Disc Nature-Duration-Complexity YN` = 0,
              `Disc Nature-Duration-Complexity Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Disc Consequences of Failure` = NULL,
              `Disc Consequences of Failure YN` = 0,
              `Disc Consequences of Failure Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test Proc Rec" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Test Proc Rec Com` = NULL,
              `Test Proc Rec YN` = 0,
              `Test Proc Rec Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Spec" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Prod Spec Com` = NULL,
              `Prod Spec YN` = 0,
              `Prod Spec Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "OK on Raws" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `OK on Raws Com` = NULL,
              `OK on Raws YN` = 0,
              `OK on Raws Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Prod Code Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Prod Code Entered Com` = NULL,
              `Prod Code Entered YN` = 0,
              `Prod Code Entered Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MSDS Init" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `MSDS Init Com` = NULL,
              `MSDS Init YN` = 0,
              `MSDS Init Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Lab Batch" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Lab Batch Com` = NULL,
              `Lab Batch YN` = 0,
              `Lab Batch Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "QC Tests Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `QC Tests Entered Com` = NULL,
              `QC Tests Entered YN` = 0,
              `QC Tests Entered Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Formula Entered" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Formula Entered Com` = NULL,
              `Formula Entered YN` = 0,
              `Formula Entered Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "MOC" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `MOC_Com` = NULL,
              `MOC_YN` = 0,
              `MOC_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Env_Aspects" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Env_Aspects_Com` = NULL,
              `Env_Aspects_YN` = 0,
              `Env_Aspects_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Sr_Mgmt_Rev_Com` = NULL,
              `Sr_Mgmt_Rev_YN` = 0,
              `Sr_Mgmt_Rev_Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Form to Purch Mang Com` = NULL,
              `Form to Purch Mang YN` = 0,
              `Form to Purch Mang Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      ELSEIF @STEP_CODE = "Test proc Forw" THEN
        UPDATE #{destination_db}.new_product_progress_data
          SET `Test proc Forw Com` = NULL,
              `Test proc Forw YN` = 0,
              `Test proc Forw Date` = NULL
        WHERE `Product Code` = @PRODUCT_CODE;
      END IF;

    END thisTrigger
    SQL
  end

end
