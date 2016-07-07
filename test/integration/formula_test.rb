require 'test_helper'

module Integration
  class Formula < ActiveSupport::TestCase

    def setup
      @data = {
        insert: {
          code: 'test code1',
          name: 'test name1',
          state: 'test status1',
          comments: 'test comments1',
          sales_to_date: 101,
          reviewed_by: 'Steve1'
        }
      }

      # reset session variables @TRIGGER_CHECKS_CHEMFIL1
      ActiveRecord::Base.connection.reset!
    end

    test 'insert formula' do
      sql = <<-SQL
        SELECT *
        FROM chemfil1_test.new_product_progress_data
        WHERE `Product Code` = "#{@data[:insert][:code]}";
      SQL


      formula = ::Formula.create!(@data[:insert])
      r = ActiveRecord::Base.connection.raw_connection.query(sql, as: :hash)

      assert_equal 1, r.count
      assert_equal @data[:insert][:code], r.first['Product Code']
      assert_equal @data[:insert][:name], r.first['Product Name']
      assert_equal @data[:insert][:state], r.first['Status']
      assert_equal @data[:insert][:comments], r.first['Comments']
      assert_equal @data[:insert][:sales_to_date], r.first['Sales to Date']
      assert_equal @data[:insert][:reviewed_by], r.first['Sr_Mgmt_Rev_BY']
    end

  end
end
