require 'test_helper'

module Integration
  module Chemfil1
    class NewProductProgressData < ActiveSupport::TestCase

      def setup
        @data = {
          insert: {
            code: 'test code',
            name: 'test name',
            state: 'test status',
            comments: 'test comments',
            sales_to_date: 10,
            reviewed_by: 'Steve'
          }
        }

        # reset session variables @TRIGGER_CHECKS_DIMACHEM
        ActiveRecord::Base.connection.reset!
      end

      test 'insert new product progress data' do
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

        ActiveRecord::Base.connection.execute(sql)
        formula = ::Formula.find_by_code(@data[:insert][:code])

        assert_equal(@data[:insert][:code], formula.code)
      end

      # test 'update new product progress data'

      # test 'delete new product progress data'

    end
  end
end
