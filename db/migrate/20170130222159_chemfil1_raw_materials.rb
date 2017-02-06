include MigrationHelper

class Chemfil1RawMaterials < ActiveRecord::Migration
  def up
    sql = <<-SQL
-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.`Raw Materials`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `raw_materials` (
  `CHAMP CODE` VARCHAR(255) NOT NULL,
  `NAME` VARCHAR(255) NULL,
  `SUPPLIER1` VARCHAR(255) NULL,
  `VOLUME1` VARCHAR(255) NULL,
  `SUPPLIER2` VARCHAR(255) NULL,
  `SUPPLIER3` VARCHAR(255) NULL,
  `LBS PER GAL` DOUBLE NULL,
  `MIN POUNDS` DOUBLE NULL,
  `QC` VARCHAR(255) NULL,
  `RAW MATERIAL`VARCHAR(255) NULL,
  `DATE CODED` DATETIME NULL,
  `CODED BY` VARCHAR(255) NULL,
  `TYPE` VARCHAR(255) NULL,
  `DSL COMPLIANT` VARCHAR(255) NULL,
  `NDSL TRIGGER` DOUBLE NULL,
  `SAMPLE` TINYINT(1) NOT NULL DEFAULT 1,
  `SAMPLE CONTAINER` VARCHAR(255) NULL,
  `SAMPLE MIX` TINYINT(1) NOT NULL DEFAULT 1,
  `PurchComments` VARCHAR(255) NULL,
  `UsedInAutoProdParts` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`CHAMP CODE`)); -- has NULLs
SQL

    Chemfil1Migration.execute(sql)
  end

  def down
    @connection = Chemfil1Migration.establish_connection.connection
    drop_table :raw_materials
  end
end
