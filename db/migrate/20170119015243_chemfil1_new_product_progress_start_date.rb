include MigrationHelper

class Chemfil1NewProductProgressStartDate < ActiveRecord::Migration
  def up
    # sets the connection for create_trigger
    @connection = Chemfil1Migration.establish_connection.connection

    # removing comments field from New_Product_Progress_Data triggers
    drop_trigger("New_Product_Progress_Data_AFTER_INSERT", "New_Product_Progress_Data", :generated => true)

    drop_trigger("New_Product_Progress_Data_AFTER_UPDATE", "New_Product_Progress_Data", :generated => true)

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
            (code, name, priority, state, reviewed_by, start_date, requested_by, customer, created_at, updated_at)
          VALUES
            (
              NEW.`Product Code`,
              NEW.`Product Name`,
              NEW.`Priority`,
              LCASE(NEW.`Status`),
              NEW.`Sr_Mgmt_Rev_BY`,
              NEW.`Start Date`,
              NEW.`Requested By`,
              NEW.`Customer`,
              NOW(), NOW());

          SET @FORMULA_ID = LAST_INSERT_ID();

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
                  NEW.`Sr_Mgmt_Rev_Com` AS comments,
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
                priority = NEW.`Priority`,
                state = LCASE(NEW.`Status`),
                reviewed_by = NEW.`Sr_Mgmt_Rev_BY`,
                start_date = NEW.`Start Date`,
                requested_by = NEW.`Requested By`,
                customer = NEW.`Customer`,
                updated_at = NOW()
          WHERE code = OLD.`Product Code`;

          SELECT id FROM #{destination_db}.formulas WHERE code = NEW.`Product Code` INTO @FORMULA_ID;

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
                comments = NEW.`Sr_Mgmt_Rev_Com`,
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
                NEW.`Sr_Mgmt_Rev_Com` AS comments,
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

  end

  def down
    # sets the connection for create_trigger
    @connection = Chemfil1Migration.establish_connection.connection

    # removing comments field from New_Product_Progress_Data triggers
    drop_trigger("New_Product_Progress_Data_AFTER_INSERT", "New_Product_Progress_Data", :generated => true)

    drop_trigger("New_Product_Progress_Data_AFTER_UPDATE", "New_Product_Progress_Data", :generated => true)

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
            (code, name, priority, state, reviewed_by, created_at, updated_at)
          VALUES
            (
              NEW.`Product Code`,
              NEW.`Product Name`,
              NEW.`Priority`,
              LCASE(NEW.`Status`),
              NEW.`Sr_Mgmt_Rev_BY`,
              NOW(), NOW());

          SET @FORMULA_ID = LAST_INSERT_ID();

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
                  NEW.`Sr_Mgmt_Rev_Com` AS comments,
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
                priority = NEW.`Priority`,
                state = LCASE(NEW.`Status`),
                reviewed_by = NEW.`Sr_Mgmt_Rev_BY`,
                updated_at = NOW()
          WHERE code = OLD.`Product Code`;

          SELECT id FROM #{destination_db}.formulas WHERE code = NEW.`Product Code` INTO @FORMULA_ID;

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
                comments = NEW.`Sr_Mgmt_Rev_Com`,
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
                NEW.`Sr_Mgmt_Rev_Com` AS comments,
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

  end
end
