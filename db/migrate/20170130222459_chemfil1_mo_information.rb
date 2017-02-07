include MigrationHelper

class Chemfil1MoInformation < ActiveRecord::Migration
  def up
    sql1 = <<-SQL
-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.mo_information
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mo_information` (
  `Product Code` VARCHAR(255) NOT NULL,
  `ISSUE DATE` DATETIME NULL,
  `ISSUED BY` VARCHAR(255) NULL,
  `REVISION DATE` DATETIME NULL,
  `REVISED BY` VARCHAR(255) NULL,
  `HANDLING INST` VARCHAR(255) NULL,
  `SAFETY EQUIP` VARCHAR(255) NULL,
  `LABEL` VARCHAR(255) NULL,
  `BATCH LBS` DOUBLE NULL,
  `BATCH DR` VARCHAR(255) NULL,
  `YIELD` DOUBLE NULL,
  `ACTIVE` TINYINT(1) NOT NULL DEFAULT 1,
  `DATE NON ACT` DATETIME NULL,
  `FLAG` VARCHAR(255) NULL,
  `FLAG SOURCE` VARCHAR(255) NULL,
  `CLASS` VARCHAR(255) NULL,
  `Sub Class` VARCHAR(255) NULL,
  `ID REQUIRED` VARCHAR(255) NULL,
  `StorageLocation` VARCHAR(255) NULL,
  `DockAudit` VARCHAR(255) NULL,
  `LeadTime` DOUBLE NULL,
  PRIMARY KEY (`Product Code`)
  );
SQL

    Chemfil1Migration.execute(sql1)
  end

  def down
    @connection = Chemfil1Migration.establish_connection.connection
    drop_table :mo_information
  end
end
