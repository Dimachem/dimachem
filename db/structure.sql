-- MySQL dump 10.13  Distrib 5.7.12, for Win64 (x86_64)
--
-- Host: localhost    Database: dimachem_development
-- ------------------------------------------------------
-- Server version	5.7.12-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `formulas`
--

DROP TABLE IF EXISTS `formulas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formulas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comments` text COLLATE utf8_unicode_ci,
  `reviewed_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_formulas_on_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=1363 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER formulas_after_insert_row_tr AFTER INSERT ON `formulas`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
            LEAVE thisTrigger;
          END IF;
    
          SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
          INSERT INTO chemfil1_development.new_product_progress_data
            (`Product Code`, `Product Name`, `Priority`, `Status`, `Comments`, `Sr_Mgmt_Rev_BY`)
          VALUES
            (NEW.code, NEW.name, NEW.priority, NEW.state, NEW.comments, NEW.reviewed_by);
        END thisTrigger;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER formulas_after_update_row_tr AFTER UPDATE ON `formulas`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
            LEAVE thisTrigger;
          END IF;
    
          SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
          UPDATE chemfil1_development.new_product_progress_data
            SET `Product Name` = NEW.name,
                `Priority` = New.priority,
                `Status` = NEW.state,
                `Comments` = NEW.comments,
                `Sr_Mgmt_Rev_BY` = NEW.reviewed_by
          WHERE `Product Code` = OLD.code;
        END thisTrigger;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER formulas_after_delete_row_tr AFTER DELETE ON `formulas`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF (@TRIGGER_CHECKS_CHEMFIL1 = FALSE) THEN
            LEAVE thisTrigger;
          END IF;
    
          SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
          DELETE FROM chemfil1_development.new_product_progress_data
          WHERE `Product Code` = OLD.code;
        END thisTrigger;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `formulas_assets`
--

DROP TABLE IF EXISTS `formulas_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formulas_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formula_id` int(11) DEFAULT NULL,
  `asset_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_file_size` int(11) DEFAULT NULL,
  `asset_updated_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_formulas_assets_on_formula_id` (`formula_id`),
  CONSTRAINT `fk_rails_3460af3f16` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `formulas_progress_steps`
--

DROP TABLE IF EXISTS `formulas_progress_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formulas_progress_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formula_id` int(11) DEFAULT NULL,
  `progress_step_id` int(11) DEFAULT NULL,
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `completed_on` datetime DEFAULT NULL,
  `comments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_formulas_progress_steps_on_formula_id_and_progress_step_id` (`formula_id`,`progress_step_id`),
  KEY `index_formulas_progress_steps_on_formula_id` (`formula_id`),
  KEY `index_formulas_progress_steps_on_progress_step_id` (`progress_step_id`),
  CONSTRAINT `fk_rails_f5b1e6c641` FOREIGN KEY (`progress_step_id`) REFERENCES `progress_steps` (`id`),
  CONSTRAINT `fk_rails_ff0c4ff92d` FOREIGN KEY (`formula_id`) REFERENCES `formulas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20080 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER formulas_progress_steps_after_insert_row_tr AFTER INSERT ON `formulas_progress_steps`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
            LEAVE thisTrigger;
          END IF;
    
          SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
          SELECT code FROM progress_steps WHERE id = NEW.progress_step_id INTO @STEP_CODE;
          SELECT code FROM formulas WHERE id = NEW.formula_id INTO @PRODUCT_CODE;
    
          IF @STEP_CODE = "Cust_Req" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Cust_Req_Com` = NEW.comments,
                  `Cust_Req_YN` = NEW.completed,
                  `Cust_Req_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Cust_Specs" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Cust_Specs_Com` = NEW.comments,
                  `Cust_Specs_YN` = NEW.completed,
                  `Cust_Specs_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "TDS MSDS" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `TDS MSDS Com` = NEW.comments,
                  `TDS MSDS YN` = NEW.completed,
                  `TDS MSDS Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Formula" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Formula Com` = NEW.comments,
                  `Formula YN` = NEW.completed,
                  `Formula Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Disc Nature-Duration-Complexity` = NEW.comments,
                  `Disc Nature-Duration-Complexity YN` = NEW.completed,
                  `Disc Nature-Duration-Complexity Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Disc Consequences of Failure` = NEW.comments,
                  `Disc Consequences of Failure YN` = NEW.completed,
                  `Disc Consequences of Failure Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Test Proc Rec" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Test Proc Rec Com` = NEW.comments,
                  `Test Proc Rec YN` = NEW.completed,
                  `Test Proc Rec Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Prod Spec" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Prod Spec Com` = NEW.comments,
                  `Prod Spec YN` = NEW.completed,
                  `Prod Spec Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "OK on Raws" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `OK on Raws Com` = NEW.comments,
                  `OK on Raws YN` = NEW.completed,
                  `OK on Raws Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Prod Code Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Prod Code Entered Com` = NEW.comments,
                  `Prod Code Entered YN` = NEW.completed,
                  `Prod Code Entered Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "MSDS Init" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `MSDS Init Com` = NEW.comments,
                  `MSDS Init YN` = NEW.completed,
                  `MSDS Init Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Lab Batch" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Lab Batch Com` = NEW.comments,
                  `Lab Batch YN` = NEW.completed,
                  `Lab Batch Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "QC Tests Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `QC Tests Entered Com` = NEW.comments,
                  `QC Tests Entered YN` = NEW.completed,
                  `QC Tests Entered Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Formula Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Formula Entered Com` = NEW.comments,
                  `Formula Entered YN` = NEW.completed,
                  `Formula Entered Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "MOC" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `MOC_Com` = NEW.comments,
                  `MOC_YN` = NEW.completed,
                  `MOC_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Env_Aspects" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Env_Aspects_Com` = NEW.comments,
                  `Env_Aspects_YN` = NEW.completed,
                  `Env_Aspects_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Sr_Mgmt_Rev_Com` = NEW.comments,
                  `Sr_Mgmt_Rev_YN` = NEW.completed,
                  `Sr_Mgmt_Rev_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Form to Purch Mang Com` = NEW.comments,
                  `Form to Purch Mang YN` = NEW.completed,
                  `Form to Purch Mang Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Test proc Forw" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Test proc Forw Com` = NEW.comments,
                  `Test proc Forw YN` = NEW.completed,
                  `Test proc Forw Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          END IF;
    
        END thisTrigger;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER formulas_progress_steps_after_update_row_tr AFTER UPDATE ON `formulas_progress_steps`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
            LEAVE thisTrigger;
          END IF;
    
          SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
          SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
          SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;
    
          IF @STEP_CODE = "Cust_Req" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Cust_Req_Com` = NEW.comments,
                  `Cust_Req_YN` = NEW.completed,
                  `Cust_Req_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Cust_Specs" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Cust_Specs_Com` = NEW.comments,
                  `Cust_Specs_YN` = NEW.completed,
                  `Cust_Specs_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "TDS MSDS" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `TDS MSDS Com` = NEW.comments,
                  `TDS MSDS YN` = NEW.completed,
                  `TDS MSDS Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Formula" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Formula Com` = NEW.comments,
                  `Formula YN` = NEW.completed,
                  `Formula Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Disc Nature-Duration-Complexity` = NEW.comments,
                  `Disc Nature-Duration-Complexity YN` = NEW.completed,
                  `Disc Nature-Duration-Complexity Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Disc Consequences of Failure` = NEW.comments,
                  `Disc Consequences of Failure YN` = NEW.completed,
                  `Disc Consequences of Failure Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Test Proc Rec" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Test Proc Rec Com` = NEW.comments,
                  `Test Proc Rec YN` = NEW.completed,
                  `Test Proc Rec Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Prod Spec" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Prod Spec Com` = NEW.comments,
                  `Prod Spec YN` = NEW.completed,
                  `Prod Spec Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "OK on Raws" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `OK on Raws Com` = NEW.comments,
                  `OK on Raws YN` = NEW.completed,
                  `OK on Raws Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Prod Code Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Prod Code Entered Com` = NEW.comments,
                  `Prod Code Entered YN` = NEW.completed,
                  `Prod Code Entered Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "MSDS Init" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `MSDS Init Com` = NEW.comments,
                  `MSDS Init YN` = NEW.completed,
                  `MSDS Init Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Lab Batch" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Lab Batch Com` = NEW.comments,
                  `Lab Batch YN` = NEW.completed,
                  `Lab Batch Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "QC Tests Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `QC Tests Entered Com` = NEW.comments,
                  `QC Tests Entered YN` = NEW.completed,
                  `QC Tests Entered Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Formula Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Formula Entered Com` = NEW.comments,
                  `Formula Entered YN` = NEW.completed,
                  `Formula Entered Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "MOC" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `MOC_Com` = NEW.comments,
                  `MOC_YN` = NEW.completed,
                  `MOC_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Env_Aspects" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Env_Aspects_Com` = NEW.comments,
                  `Env_Aspects_YN` = NEW.completed,
                  `Env_Aspects_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Sr_Mgmt_Rev_Com` = NEW.comments,
                  `Sr_Mgmt_Rev_YN` = NEW.completed,
                  `Sr_Mgmt_Rev_Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Form to Purch Mang Com` = NEW.comments,
                  `Form to Purch Mang YN` = NEW.completed,
                  `Form to Purch Mang Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Test proc Forw" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Test proc Forw Com` = NEW.comments,
                  `Test proc Forw YN` = NEW.completed,
                  `Test proc Forw Date` = NEW.completed_on
            WHERE `Product Code` = @PRODUCT_CODE;
          END IF;
    
        END thisTrigger;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER formulas_progress_steps_after_delete_row_tr AFTER DELETE ON `formulas_progress_steps`
FOR EACH ROW
BEGIN
        thisTrigger: BEGIN
          IF @TRIGGER_CHECKS_CHEMFIL1 = FALSE THEN
            LEAVE thisTrigger;
          END IF;
    
          SET @TRIGGER_CHECKS_DIMACHEM = FALSE;
          SELECT code FROM progress_steps WHERE id = OLD.progress_step_id INTO @STEP_CODE;
          SELECT code FROM formulas WHERE id = OLD.formula_id INTO @PRODUCT_CODE;
    
          IF @STEP_CODE = "Cust_Req" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Cust_Req_Com` = NULL,
                  `Cust_Req_YN` = 0,
                  `Cust_Req_Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Cust_Specs" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Cust_Specs_Com` = NULL,
                  `Cust_Specs_YN` = 0,
                  `Cust_Specs_Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "TDS MSDS" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `TDS MSDS Com` = NULL,
                  `TDS MSDS YN` = 0,
                  `TDS MSDS Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Formula" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Formula Com` = NULL,
                  `Formula YN` = 0,
                  `Formula Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Disc Nature-Duration-Complexity" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Disc Nature-Duration-Complexity` = NULL,
                  `Disc Nature-Duration-Complexity YN` = 0,
                  `Disc Nature-Duration-Complexity Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Disc Consequences of Failure" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Disc Consequences of Failure` = NULL,
                  `Disc Consequences of Failure YN` = 0,
                  `Disc Consequences of Failure Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Test Proc Rec" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Test Proc Rec Com` = NULL,
                  `Test Proc Rec YN` = 0,
                  `Test Proc Rec Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Prod Spec" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Prod Spec Com` = NULL,
                  `Prod Spec YN` = 0,
                  `Prod Spec Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "OK on Raws" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `OK on Raws Com` = NULL,
                  `OK on Raws YN` = 0,
                  `OK on Raws Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Prod Code Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Prod Code Entered Com` = NULL,
                  `Prod Code Entered YN` = 0,
                  `Prod Code Entered Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "MSDS Init" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `MSDS Init Com` = NULL,
                  `MSDS Init YN` = 0,
                  `MSDS Init Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Lab Batch" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Lab Batch Com` = NULL,
                  `Lab Batch YN` = 0,
                  `Lab Batch Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "QC Tests Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `QC Tests Entered Com` = NULL,
                  `QC Tests Entered YN` = 0,
                  `QC Tests Entered Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Formula Entered" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Formula Entered Com` = NULL,
                  `Formula Entered YN` = 0,
                  `Formula Entered Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "MOC" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `MOC_Com` = NULL,
                  `MOC_YN` = 0,
                  `MOC_Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Env_Aspects" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Env_Aspects_Com` = NULL,
                  `Env_Aspects_YN` = 0,
                  `Env_Aspects_Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Sr_Mgmt_Rev" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Sr_Mgmt_Rev_Com` = NULL,
                  `Sr_Mgmt_Rev_YN` = 0,
                  `Sr_Mgmt_Rev_Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Form to Purch Mang" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Form to Purch Mang Com` = NULL,
                  `Form to Purch Mang YN` = 0,
                  `Form to Purch Mang Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          ELSEIF @STEP_CODE = "Test proc Forw" THEN
            UPDATE chemfil1_development.new_product_progress_data
              SET `Test proc Forw Com` = NULL,
                  `Test proc Forw YN` = 0,
                  `Test proc Forw Date` = NULL
            WHERE `Product Code` = @PRODUCT_CODE;
          END IF;
    
        END thisTrigger;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `progress_steps`
--

DROP TABLE IF EXISTS `progress_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progress_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `position` int(11) NOT NULL,
  `effective_on` datetime NOT NULL,
  `effective_until` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_progress_steps_on_code` (`code`),
  UNIQUE KEY `index_progress_steps_on_description` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-10-04  9:53:38
INSERT INTO schema_migrations (version) VALUES ('20160521131000');

INSERT INTO schema_migrations (version) VALUES ('20160609141334');

INSERT INTO schema_migrations (version) VALUES ('20160609142324');

INSERT INTO schema_migrations (version) VALUES ('20160609144324');

INSERT INTO schema_migrations (version) VALUES ('20160609165759');

INSERT INTO schema_migrations (version) VALUES ('20160616184511');

INSERT INTO schema_migrations (version) VALUES ('20160625203007');

INSERT INTO schema_migrations (version) VALUES ('20160729191516');

INSERT INTO schema_migrations (version) VALUES ('20160815011715');

