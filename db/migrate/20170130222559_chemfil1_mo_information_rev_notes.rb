include MigrationHelper

class Chemfil1MoInformationRevNotes < ActiveRecord::Migration
  def up
    sql1 = <<-SQL
-- ----------------------------------------------------------------------------
-- Table CHEMFIL1.mo_information_rev_notes
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mo_information_rev_notes` (
  `Product Code` VARCHAR(255) NOT NULL,
  `REV NOTES` TEXT NULL,
  UNIQUE INDEX (`Product Code`),
  FOREIGN KEY (`Product Code`) REFERENCES `mo_information`(`Product Code`) ON DELETE CASCADE
  );
SQL

    Chemfil1Migration.execute(sql1)
  end

  def down
    @connection = Chemfil1Migration.establish_connection.connection
    drop_table :mo_information_rev_notes
  end
end
