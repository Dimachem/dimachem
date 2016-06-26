-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: CHEMFIL1
-- Source Schemata: CHEMFIL1
-- Created: Sat May 21 13:11:51 2016
-- Workbench Version: 6.3.6
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema CHEMFIL1
-- ----------------------------------------------------------------------------
-- DROP SCHEMA IF EXISTS `CHEMFIL1` ;
CREATE SCHEMA IF NOT EXISTS `CHEMFIL1` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;

-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.New_Product_Progress_Data
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `CHEMFIL1`.`New_Product_Progress_Data` (
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
SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------------------------------------------------------
-- Trigger CHEMFIL1.New_Product_Progress_Data_AFTER_INSERT
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER `CHEMFIL1`.`New_Product_Progress_Data_AFTER_INSERT` AFTER INSERT
ON `CHEMFIL1`.`New_Product_Progress_Data`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_DIMACHEM = FALSE) THEN
            LEAVE thisTrigger;
          END IF;

          SET @TRIGGER_CHECKS_CHEMFIL1 = FALSE;
          INSERT INTO dimachem_development.formulas
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

          SET @formula_id = LAST_INSERT_ID();

          INSERT INTO dimachem_development.formulas_progress_steps
            (formula_id, progress_step_id, comments, completed, completed_on, created_at, updated_at)
          SELECT @formula_id, progress_steps.id,
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
              dimachem_development.progress_steps
          WHERE (temp_fps.comments IS NOT NULL
            OR temp_fps.completed = TRUE
            OR temp_fps.completed_on IS NOT NULL)
            AND temp_fps.step_code = progress_steps.code;

        END thisTrigger;
END$$

DELIMITER ;
