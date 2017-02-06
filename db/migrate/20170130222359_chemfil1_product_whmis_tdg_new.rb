include MigrationHelper

class Chemfil1ProductWhmisTdgNew < ActiveRecord::Migration
  def up
    sql = <<-SQL
-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.`Brands`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `product_whmis_tdg_new` (
  `INVENTCODE` VARCHAR(255) NOT NULL,
  `WHMIS CLASS` VARCHAR(255) NULL,
  `TDG SHIP NAME` VARCHAR(255) NULL,
  `TDG CLASS` VARCHAR(255) NULL,
  `TDG UN#` DOUBLE NULL,
  `TDG PG` VARCHAR(255) NULL,
  `TDG PLACARD` VARCHAR(255) NULL,
  `Label Code` SMALLINT NULL,
  PRIMARY KEY (`INVENTCODE`)); -- has NULLs
SQL

    Chemfil1Migration.execute(sql)
  end

  def down
    @connection = Chemfil1Migration.establish_connection.connection
    drop_table :product_whmis_tdg_new
  end
end
