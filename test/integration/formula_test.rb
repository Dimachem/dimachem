require 'test_helper'

module Integration
  class Formula < ActiveSupport::TestCase

    def setup
      @data = {
        insert: {
          code: SecureRandom.uuid,
          name: 'inserted name',
          state: 'inserted status',
          comments: 'inserted comments',
          sales_to_date: 10,
          reviewed_by: 'inserted reviewer'
        },
        update: {
          name: 'updated name',
          state: 'updated status',
          comments: 'updated comments',
          sales_to_date: 100,
          reviewed_by: 'updated reviewer'
        }
      }

      # reset session variables @TRIGGER_CHECKS_CHEMFIL1
      ActiveRecord::Base.connection.reset!
    end

    test 'insert formula' do
      formula = ::Formula.create!(@data[:insert])
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql, as: :hash)

      assert_equal 1, r.count
      assert_equal @data[:insert][:code], r.first['Product Code']
      assert_equal @data[:insert][:name], r.first['Product Name']
      assert_equal @data[:insert][:state], r.first['Status']
      assert_equal @data[:insert][:comments], r.first['Comments']
      assert_equal @data[:insert][:sales_to_date], r.first['Sales to Date']
      assert_equal @data[:insert][:reviewed_by], r.first['Sr_Mgmt_Rev_BY']
    end

    test 'update formula' do
      ActiveRecord::Base.connection.execute(insert_sql)
      ActiveRecord::Base.connection.reset!

      formula = ::Formula.find_by_code!(@data[:insert][:code])
      formula.update_attributes!(@data[:update])
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql, as: :hash)

      assert_equal @data[:insert][:code], r.first['Product Code']
      assert_equal @data[:update][:name], r.first['Product Name']
      assert_equal @data[:update][:state], r.first['Status']
      assert_equal @data[:update][:comments], r.first['Comments']
      assert_equal @data[:update][:sales_to_date], r.first['Sales to Date']
      assert_equal @data[:update][:reviewed_by], r.first['Sr_Mgmt_Rev_BY']
    end

    test 'delete formula' do
      ActiveRecord::Base.connection.execute(insert_sql)
      ActiveRecord::Base.connection.reset!

      formula = ::Formula.find_by_code!(@data[:insert][:code])
      formula.destroy
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql, as: :hash)

      assert_equal 0, r.count
    end

    private

    def select_sql
      <<-SQL
        SELECT *
        FROM chemfil1_test.new_product_progress_data
        WHERE `Product Code` = "#{@data[:insert][:code]}";
      SQL
    end

    def insert_sql
      sql = <<-SQL
        INSERT INTO chemfil1_test.new_product_progress_data
          (`Product Code`, `Product Name`, `Status`, `Comments`, `Sales to Date`, `Sr_Mgmt_Rev_BY`)
        VALUES (
          "#{@data[:insert][:code]}",
          "#{@data[:insert][:name]}",
          "#{@data[:insert][:state]}",
          "#{@data[:insert][:comments]}",
          "#{@data[:insert][:sales_to_date]}",
          "#{@data[:insert][:reviewed_by]}"
        )
      SQL
    end

  end
end
