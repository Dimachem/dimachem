include MigrationHelper

class AddRevNotesToMoInformation < ActiveRecord::Migration
  def up
    sql1 = <<-SQL
    ALTER TABLE `mo_information`
      ADD `REV NOTES` VARCHAR(255) NOT NULL DEFAULT 'Field Deprecated - Contact Steve Cox';
    SQL

    Chemfil1Migration.execute(sql1)
  end

  def down
    @connection = Chemfil1Migration.establish_connection.connection
    remove_column :mo_information, 'REV NOTES'
  end
end
