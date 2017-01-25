module MigrationHelper
  class Chemfil1Migration < ActiveRecord::Base
    def self.establish_connection
      super("#{Rails.env}_sync".to_sym)
    end

    def self.execute(sql)
      establish_connection

      transaction do
        connection.execute("SET FOREIGN_KEY_CHECKS = 0;")
        connection.execute(sql)
        connection.execute("SET FOREIGN_KEY_CHECKS = 1;")
      end
    end
  end
end
