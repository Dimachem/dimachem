include MigrationHelper

class Chemfil1NewProductProgressData < ActiveRecord::Migration
  def up
    sql = <<-SQL
-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.New_Product_Progress_Data
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `New_Product_Progress_Data` (
  `Product Code` VARCHAR(255) NOT NULL,
  `Product Name` VARCHAR(255) NULL,
  -- `MATERIAL ID` VARCHAR(255) NULL,
  `Start Date` DATETIME NULL,
  `Sales Request?` TINYINT(1) NOT NULL DEFAULT 0,
  `Priority` INT(10) NULL,
  `EMail Notification?` TINYINT(1) NOT NULL DEFAULT 0,
  `Requested By` VARCHAR(255) NULL,
  `Customer` VARCHAR(255) NULL,
  `Disc Nature-Duration-Complexity` VARCHAR(255) NULL,
  `Disc Nature-Duration-Complexity YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Disc Nature-Duration-Complexity Date` DATETIME NULL,
  `Disc Consequences of Failure` VARCHAR(255) NULL,
  `Disc Consequences of Failure YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Disc Consequences of Failure Date` DATETIME NULL,
  `TDS MSDS YN` TINYINT(1) NOT NULL DEFAULT 0,
  `TDS MSDS Date` DATETIME NULL,
  `TDS MSDS Com` VARCHAR(255) NULL,
  `Formula YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Formula Date` DATETIME NULL,
  `Formula Com` VARCHAR(255) NULL,
  `Test Proc Rec YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Test Proc Rec Date` DATETIME NULL,
  `Test Proc Rec Com` VARCHAR(255) NULL,
  `Prod Spec YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Prod Spec Date` DATETIME NULL,
  `Prod Spec Com` VARCHAR(255) NULL,
  `Form to Purch Mang YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Form to Purch Mang Date` DATETIME NULL,
  `Form to Purch Mang Com` VARCHAR(255) NULL,
  `Test proc Forw YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Test proc Forw Date` DATETIME NULL,
  `Test proc Forw Com` VARCHAR(255) NULL,
  `OK on Raws YN` TINYINT(1) NOT NULL DEFAULT 0,
  `OK on Raws Date` DATETIME NULL,
  `OK on Raws Com` VARCHAR(255) NULL,
  `Prod Code Entered YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Prod Code Entered Date` DATETIME NULL,
  `Prod Code Entered Com` VARCHAR(255) NULL,
  `MSDS Init YN` TINYINT(1) NOT NULL DEFAULT 0,
  `MSDS Init Date` DATETIME NULL,
  `MSDS Init Com` VARCHAR(255) NULL,
  `Lab Batch YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Lab Batch Date` DATETIME NULL,
  `Lab Batch Com` VARCHAR(255) NULL,
  `QC Tests Entered YN` TINYINT(1) NOT NULL DEFAULT 0,
  `QC Tests Entered Date` DATETIME NULL,
  `QC Tests Entered Com` VARCHAR(255) NULL,
  `Formula Entered YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Formula Entered Date` DATETIME NULL,
  `Formula Entered Com` VARCHAR(255) NULL,
  `Comments` TEXT NULL,
  `Status` VARCHAR(255) NULL,
  -- `Formula Image` MEDIUMBLOB NULL,
  -- `FileName` VARCHAR(255) NULL,
  -- `ContentType` VARCHAR(255) NULL,
  -- `FileSize` INT(10) NULL,
  -- `QC Image` MEDIUMBLOB NULL,
  -- `Other Image` MEDIUMBLOB NULL,
  `Env_Aspects_YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Env_Aspects_Date` DATETIME NULL,
  `Env_Aspects_Com` VARCHAR(255) NULL,
  `Cust_Req_YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Cust_Req_Date` DATETIME NULL,
  `Cust_Req_Com` VARCHAR(255) NULL,
  `Cust_Specs_YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Cust_Specs_Date` DATETIME NULL,
  `Cust_Specs_Com` VARCHAR(255) NULL,
  `MOC_YN` TINYINT(1) NOT NULL DEFAULT 0,
  `MOC_Date` DATETIME NULL,
  `MOC_Com` VARCHAR(255) NULL,
  `Sr_Mgmt_Rev_YN` TINYINT(1) NOT NULL DEFAULT 0,
  `Sr_Mgmt_Rev_Date` DATETIME NULL,
  `Sr_Mgmt_Rev_Comment` VARCHAR(255) NULL,
  `Sr_Mgmt_Rev_BY` VARCHAR(255) NULL,
  `Sales to Date` DECIMAL(19,4) NULL,
  -- INDEX `MATERIAL ID` (`MATERIAL ID` ASC),
  PRIMARY KEY (`Product Code`));
SQL

    Chemfil1Migration.execute(sql)

    # sets the connection for create_trigger
    @connection = Chemfil1Migration.connection

    create_trigger("New_Product_Progress_Data_AFTER_INSERT", :generated => false, :compatibility => 1).
        on("New_Product_Progress_Data").
        after(:insert) do
      destination_db = Rails.application.config.database_configuration()[Rails.env]['database']

      <<-SQL_ACTIONS
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_DIMACHEM = FALSE) THEN
            LEAVE thisTrigger;
          END IF;

          SET @TRIGGER_CHECKS_CHEMFIL1 = FALSE;
          INSERT INTO #{destination_db}.formulas
            (code, name, state, comments, sales_to_date, reviewed_by, created_at, updated_at)
          VALUES
            (
              NEW.`Product Code`,
              NEW.`Product Name`,
              NEW.`Status`,
              NEW.`Comments`,
              NEW.`Sales to Date`,
              NEW.`Sr_Mgmt_Rev_BY`,
              NOW(), NOW());

          SET @FORMULA_ID = LAST_INSERT_ID();

          -- INSERT INTO #{destination_db}.formulas_assets
          --   (formula_id, asset_file_name, asset_content_type, asset_file_size, asset_updated_at, created_at, updated_at)
          -- VALUES
          --   (
          --     @FORMULA_ID,
          --     NEW.`FileName`,
          --     NEW.`ContentType`,
          --     NEW.`FileSize`,
          --     NOW(), NOW(), NOW());

          INSERT INTO #{destination_db}.formulas_progress_steps
            (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
          SELECT @FORMULA_ID, progress_steps.id,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
          FROM (
          SELECT  NEW.`Product Code` AS formula_code,
                  "Disc Nature-Duration-Complexity" AS step_code,
                  NEW.`Disc Nature-Duration-Complexity` AS comments,
                  NEW.`Disc Nature-Duration-Complexity YN` AS completed,
                  NEW.`Disc Nature-Duration-Complexity Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Disc Consequences of Failure" AS step_code,
                  NEW.`Disc Consequences of Failure` AS comments,
                  NEW.`Disc Consequences of Failure YN` AS completed,
                  NEW.`Disc Consequences of Failure Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "TDS MSDS" AS step_code,
                  NEW.`TDS MSDS Com` AS comments,
                  NEW.`TDS MSDS YN` AS completed,
                  NEW.`TDS MSDS Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Formula" AS step_code,
                  NEW.`Formula Com` AS comments,
                  NEW.`Formula YN` AS completed,
                  NEW.`Formula Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Test Proc Rec" AS step_code,
                  NEW.`Test Proc Rec Com` AS comments,
                  NEW.`Test Proc Rec YN` AS completed,
                  NEW.`Test Proc Rec Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Prod Spec" AS step_code,
                  NEW.`Prod Spec Com` AS comments,
                  NEW.`Prod Spec YN` AS completed,
                  NEW.`Prod Spec Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Form to Purch Mang" AS step_code,
                  NEW.`Form to Purch Mang Com` AS comments,
                  NEW.`Form to Purch Mang YN` AS completed,
                  NEW.`Form to Purch Mang Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Test proc Forw" AS step_code,
                  NEW.`Test proc Forw Com` AS comments,
                  NEW.`Test proc Forw YN` AS completed,
                  NEW.`Test proc Forw Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "OK on Raws" AS step_code,
                  NEW.`OK on Raws Com` AS comments,
                  NEW.`OK on Raws YN` AS completed,
                  NEW.`OK on Raws Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Prod Code Entered" AS step_code,
                  NEW.`Prod Code Entered Com` AS comments,
                  NEW.`Prod Code Entered YN` AS completed,
                  NEW.`Prod Code Entered Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "MSDS Init" AS step_code,
                  NEW.`MSDS Init Com` AS comments,
                  NEW.`MSDS Init YN` AS completed,
                  NEW.`MSDS Init Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Lab Batch" AS step_code,
                  NEW.`Lab Batch Com` AS comments,
                  NEW.`Lab Batch YN` AS completed,
                  NEW.`Lab Batch Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "QC Tests Entered" AS step_code,
                  NEW.`QC Tests Entered Com` AS comments,
                  NEW.`QC Tests Entered YN` AS completed,
                  NEW.`QC Tests Entered Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Formula Entered" AS step_code,
                  NEW.`Formula Entered Com` AS comments,
                  NEW.`Formula Entered YN` AS completed,
                  NEW.`Formula Entered Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Env_Aspects" AS step_code,
                  NEW.`Env_Aspects_Com` AS comments,
                  NEW.`Env_Aspects_YN` AS completed,
                  NEW.`Env_Aspects_Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Cust_Req" AS step_code,
                  NEW.`Cust_Req_Com` AS comments,
                  NEW.`Cust_Req_YN` AS completed,
                  NEW.`Cust_Req_Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Cust_Specs" AS step_code,
                  NEW.`Cust_Specs_Com` AS comments,
                  NEW.`Cust_Specs_YN` AS completed,
                  NEW.`Cust_Specs_Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "MOC" AS step_code,
                  NEW.`MOC_Com` AS comments,
                  NEW.`MOC_YN` AS completed,
                  NEW.`MOC_Date` AS completed_on
          UNION ALL
          SELECT  NEW.`Product Code` AS code,
                  "Sr_Mgmt_Rev" AS step_code,
                  NEW.`Sr_Mgmt_Rev_Comment` AS comments,
                  NEW.`Sr_Mgmt_Rev_YN` AS completed,
                  NEW.`Sr_Mgmt_Rev_Date` AS completed_on ) AS temp_fps,
              #{destination_db}.progress_steps
          WHERE (temp_fps.comments IS NOT NULL
            OR temp_fps.completed = TRUE
            OR temp_fps.completed_on IS NOT NULL)
            AND temp_fps.step_code = progress_steps.code;

        END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("New_Product_Progress_Data_AFTER_UPDATE", :generated => false, :compatibility => 1).
        on("New_Product_Progress_Data").
        after(:update) do
      destination_db = Rails.application.config.database_configuration()[Rails.env]['database']

      <<-SQL_ACTIONS
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_DIMACHEM = FALSE) THEN
            LEAVE thisTrigger;
          END IF;

          SET @TRIGGER_CHECKS_CHEMFIL1 = FALSE;
          UPDATE #{destination_db}.formulas
            SET code = NEW.`Product Code`,
                name = NEW.`Product Name`,
                state = NEW.`Status`,
                comments = NEW.`Comments`,
                sales_to_date = NEW.`Sales to Date`,
                reviewed_by = NEW.`Sr_Mgmt_Rev_BY`,
                updated_at = NOW()
          WHERE code = OLD.`Product Code`;

          SELECT id FROM #{destination_db}.formulas WHERE code = NEW.`Product Code` INTO @FORMULA_ID;

          -- This could update multiple records - disabled!
          -- UPDATE #{destination_db}.formulas_assets
          --   SET asset_file_name = NEW.`FileName`,
          --       asset_content_type = NEW.`ContentType`,
          --       asset_file_size = NEW.`FileSize`,
          --       asset_updated_at = NOW(),
          --       created_at = NOW(),
          --       updated_at = NOW()
          -- WHERE formula_id = @FORMULA_ID;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Disc Nature-Duration-Complexity" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Disc Nature-Duration-Complexity YN`,
                completed_on = NEW.`Disc Nature-Duration-Complexity Date`,
                comments = NEW.`Disc Nature-Duration-Complexity`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Disc Nature-Duration-Complexity` AS comments,
                NEW.`Disc Nature-Duration-Complexity YN` AS completed,
                NEW.`Disc Nature-Duration-Complexity Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Disc Consequences of Failure" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Disc Consequences of Failure YN`,
                completed_on = NEW.`Disc Consequences of Failure Date`,
                comments = NEW.`Disc Consequences of Failure`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Disc Consequences of Failure` AS comments,
                NEW.`Disc Consequences of Failure YN` AS completed,
                NEW.`Disc Consequences of Failure Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "TDS MSDS" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`TDS MSDS YN`,
                completed_on = NEW.`TDS MSDS Date`,
                comments = NEW.`TDS MSDS Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`TDS MSDS Com` AS comments,
                NEW.`TDS MSDS YN` AS completed,
                NEW.`TDS MSDS Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Formula" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Formula YN`,
                completed_on = NEW.`Formula Date`,
                comments = NEW.`Formula Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Formula Com` AS comments,
                NEW.`Formula YN` AS completed,
                NEW.`Formula Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Test Proc Rec" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Test Proc Rec YN`,
                completed_on = NEW.`Test Proc Rec Date`,
                comments = NEW.`Test Proc Rec Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Test Proc Rec Com` AS comments,
                NEW.`Test Proc Rec YN` AS completed,
                NEW.`Test Proc Rec Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Prod Spec" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Prod Spec YN`,
                completed_on = NEW.`Prod Spec Date`,
                comments = NEW.`Prod Spec Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Prod Spec Com` AS comments,
                NEW.`Prod Spec YN` AS completed,
                NEW.`Prod Spec Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Form to Purch Mang" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Form to Purch Mang YN`,
                completed_on = NEW.`Form to Purch Mang Date`,
                comments = NEW.`Form to Purch Mang Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Form to Purch Mang Com` AS comments,
                NEW.`Form to Purch Mang YN` AS completed,
                NEW.`Form to Purch Mang Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Test proc Forw" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Test proc Forw YN`,
                completed_on = NEW.`Test proc Forw Date`,
                comments = NEW.`Test proc Forw Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Test proc Forw Com` AS comments,
                NEW.`Test proc Forw YN` AS completed,
                NEW.`Test proc Forw Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "OK on Raws" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`OK on Raws YN`,
                completed_on = NEW.`OK on Raws Date`,
                comments = NEW.`OK on Raws Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`OK on Raws Com` AS comments,
                NEW.`OK on Raws YN` AS completed,
                NEW.`OK on Raws Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Prod Code Entered" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Prod Code Entered YN`,
                completed_on = NEW.`Prod Code Entered Date`,
                comments = NEW.`Prod Code Entered Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Prod Code Entered Com` AS comments,
                NEW.`Prod Code Entered YN` AS completed,
                NEW.`Prod Code Entered Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "MSDS Init" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`MSDS Init YN`,
                completed_on = NEW.`MSDS Init Date`,
                comments = NEW.`MSDS Init Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`MSDS Init Com` AS comments,
                NEW.`MSDS Init YN` AS completed,
                NEW.`MSDS Init Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Lab Batch" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Lab Batch YN`,
                completed_on = NEW.`Lab Batch Date`,
                comments = NEW.`Lab Batch Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Lab Batch Com` AS comments,
                NEW.`Lab Batch YN` AS completed,
                NEW.`Lab Batch Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "QC Tests Entered" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`QC Tests Entered YN`,
                completed_on = NEW.`QC Tests Entered Date`,
                comments = NEW.`QC Tests Entered Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`QC Tests Entered Com` AS comments,
                NEW.`QC Tests Entered YN` AS completed,
                NEW.`QC Tests Entered Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Formula Entered" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Formula Entered YN`,
                completed_on = NEW.`Formula Entered Date`,
                comments = NEW.`Formula Entered Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Formula Entered Com` AS comments,
                NEW.`Formula Entered YN` AS completed,
                NEW.`Formula Entered Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Env_Aspects" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Env_Aspects_YN`,
                completed_on = NEW.`Env_Aspects_Date`,
                comments = NEW.`Env_Aspects_Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Env_Aspects_Com` AS comments,
                NEW.`Env_Aspects_YN` AS completed,
                NEW.`Env_Aspects_Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Cust_Req" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Cust_Req_YN`,
                completed_on = NEW.`Cust_Req_Date`,
                comments = NEW.`Cust_Req_Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Cust_Req_Com` AS comments,
                NEW.`Cust_Req_YN` AS completed,
                NEW.`Cust_Req_Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Cust_Specs" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Cust_Specs_YN`,
                completed_on = NEW.`Cust_Specs_Date`,
                comments = NEW.`Cust_Specs_Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Cust_Specs_Com` AS comments,
                NEW.`Cust_Specs_YN` AS completed,
                NEW.`Cust_Specs_Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "MOC" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`MOC_YN`,
                completed_on = NEW.`MOC_Date`,
                comments = NEW.`MOC_Com`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`MOC_Com` AS comments,
                NEW.`MOC_YN` AS completed,
                NEW.`MOC_Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

          SELECT id FROM #{destination_db}.progress_steps WHERE code = "Sr_Mgmt_Rev" INTO @STEP_ID;
          UPDATE #{destination_db}.formulas_progress_steps
            SET completed = NEW.`Sr_Mgmt_Rev_YN`,
                completed_on = NEW.`Sr_Mgmt_Rev_Date`,
                comments = NEW.`Sr_Mgmt_Rev_Comment`,
                updated_at = NOW()
          WHERE progress_step_id = @STEP_ID
            AND formula_id = @FORMULA_ID;

          IF ROW_COUNT() = 0 THEN
            INSERT INTO #{destination_db}.formulas_progress_steps
              (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
            SELECT
              @FORMULA_ID,
              @STEP_ID,
              temp_fps.comments,
              temp_fps.completed,
              temp_fps.completed_on,
              NOW(),
              NOW()
            FROM (
              SELECT
                NEW.`Sr_Mgmt_Rev_Comment` AS comments,
                NEW.`Sr_Mgmt_Rev_YN` AS completed,
                NEW.`Sr_Mgmt_Rev_Date` AS completed_on
              ) AS temp_fps
            WHERE temp_fps.comments IS NOT NULL
              OR temp_fps.completed = TRUE
              OR temp_fps.completed_on IS NOT NULL;
          END IF;

        END thisTrigger;
      SQL_ACTIONS
    end

    create_trigger("New_Product_Progress_Data_AFTER_DELETE", :generated => false, :compatibility => 1).
        on("New_Product_Progress_Data").
        after(:delete) do
      destination_db = Rails.application.config.database_configuration()[Rails.env]['database']

      <<-SQL_ACTIONS
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_DIMACHEM = FALSE) THEN
            LEAVE thisTrigger;
          END IF;

          SET @TRIGGER_CHECKS_CHEMFIL1 = FALSE;

          SELECT id FROM #{destination_db}.formulas WHERE code = OLD.`Product Code` INTO @FORMULA_ID;

          DELETE FROM #{destination_db}.formulas_progress_steps
          WHERE formula_id = @FORMULA_ID;

          -- This could delete multiple records - disabled!
          -- DELETE FROM #{destination_db}.formulas_assets
          -- WHERE formula_id = @FORMULA_ID;

          DELETE FROM #{destination_db}.formulas
          WHERE id = @FORMULA_ID;

        END thisTrigger;
      SQL_ACTIONS
    end

  end

end
