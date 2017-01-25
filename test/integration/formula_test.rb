require 'test_helper'

module Integration
  class FormulaTest < ActiveSupport::TestCase

    def setup
      @data = {
        insert: {
          code: SecureRandom.uuid,
          name: 'inserted name',
          state: 'open',
          comments: 'inserted comments',
          reviewed_by: 'inserted reviewer',
          start_date: '2015-07-12 16:00:09',
          requested_by: 'inserted requester',
          customer: 'inserted customer'
        },
        update: {
          name: 'updated name',
          state: 'completed',
          comments: 'updated comments',
          reviewed_by: 'updated reviewer',
          start_date: '2016-07-12 16:00:09',
          requested_by: 'updated requester',
          customer: 'updated customer'
        }
      }

      # reset session variables @TRIGGER_CHECKS_CHEMFIL1
      ActiveRecord::Base.connection.reset!
    end

    test 'insert formula' do
      formula = Formula.create!(@data[:insert])
      rf = ActiveRecord::Base.connection.raw_connection.query(select_sql[0], as: :hash)
      rc = ActiveRecord::Base.connection.raw_connection.query(select_sql[1], as: :hash)

      assert_equal 1, rf.count
      assert_equal @data[:insert][:code], rf.first['Product Code']
      assert_equal @data[:insert][:name], rf.first['Product Name']
      assert_equal @data[:insert][:state], rf.first['Status']
      assert_equal @data[:insert][:comments], rc.first['Comments']
      assert_equal @data[:insert][:reviewed_by], rf.first['Sr_Mgmt_Rev_BY']
      assert_equal try_parse_datetime(@data[:insert][:start_date]), rf.first['Start Date']
      assert_equal @data[:insert][:requested_by], rf.first['Requested By']
      assert_equal @data[:insert][:customer], rf.first['Customer']
    end

    test 'update formula' do
      insert_sql.split(';').each {|sql| ActiveRecord::Base.connection.execute(sql)}
      ActiveRecord::Base.connection.reset!

      formula = Formula.find_by_code!(@data[:insert][:code])
      formula.update_attributes!(@data[:update])
      rf = ActiveRecord::Base.connection.raw_connection.query(select_sql[0], as: :hash)
      rc = ActiveRecord::Base.connection.raw_connection.query(select_sql[1], as: :hash)

      assert_equal @data[:insert][:code], rf.first['Product Code']
      assert_equal @data[:update][:name], rf.first['Product Name']
      assert_equal @data[:update][:state], rf.first['Status']
      assert_equal @data[:update][:comments], rc.first['Comments']
      assert_equal @data[:update][:reviewed_by], rf.first['Sr_Mgmt_Rev_BY']
      assert_equal try_parse_datetime(@data[:update][:start_date]), rf.first['Start Date']
      assert_equal @data[:update][:requested_by], rf.first['Requested By']
      assert_equal @data[:update][:customer], rf.first['Customer']
    end

    test 'delete formula' do
      insert_sql.split(';').each {|sql| ActiveRecord::Base.connection.execute(sql)}
      ActiveRecord::Base.connection.reset!

      formula = Formula.find_by_code!(@data[:insert][:code])
      formula.destroy
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql[0], as: :hash)

      assert_equal 0, r.count
    end

    private

    def select_sql
      <<-SQL
        SELECT *
        FROM chemfil1_test.new_product_progress_data
        WHERE `Product Code` = "#{@data[:insert][:code]}";

        SELECT *
        FROM chemfil1_test.new_product_progress_data_comments
        WHERE `Product Code` = "#{@data[:insert][:code]}"
      SQL
      .split(';')
    end

    def insert_sql
      sql = <<-SQL
        INSERT INTO chemfil1_test.new_product_progress_data
          (`Product Code`, `Product Name`, `Status`, `Sr_Mgmt_Rev_BY`,
            `Start Date`, `Requested By`, `Customer`)
        VALUES (
          "#{@data[:insert][:code]}",
          "#{@data[:insert][:name]}",
          "#{@data[:insert][:state]}",
          "#{@data[:insert][:reviewed_by]}",
          "#{@data[:insert][:start_date]}",
          "#{@data[:insert][:requested_by]}",
          "#{@data[:insert][:customer]}"
        );

        INSERT INTO chemfil1_test.new_product_progress_data_comments
          (`Product Code`, `Comments`)
        VALUES (
          "#{@data[:insert][:code]}",
          "#{@data[:insert][:comments]}"
        )
      SQL
    end

  end
end
