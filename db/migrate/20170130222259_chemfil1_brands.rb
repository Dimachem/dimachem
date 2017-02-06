include MigrationHelper

class Chemfil1Brands < ActiveRecord::Migration
  def up
    sql = <<-SQL
-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.`Brands`
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `brands` (
  `BRANDID` VARCHAR(255) NOT NULL,
  `BRAND` VARCHAR(255) NULL,
  `DEFAULT LABEL CODE` VARCHAR(255) NULL,
  `IMAGEPATH` VARCHAR(255) NULL,
  PRIMARY KEY (`BRANDID`)); -- has NULLs
SQL

    Chemfil1Migration.execute(sql)
  end

  def down
    @connection = Chemfil1Migration.establish_connection.connection
    drop_table :brands
  end
end
