require 'test_helper'

module Integration
  class FormulaProgressStep < ActiveSupport::TestCase

    def setup
      @step = ProgressStep.first

      @data = {
        insert_sync: {
          code: SecureRandom.uuid,
          name: 'inserted name',
          state: 'inserted status',
          comments: 'inserted comments',
          sales_to_date: 10,
          reviewed_by: 'insert reviewer',
          cust_req_yn: 1,
          cust_req_date: '2016-07-04 12:00:00',
          cust_req_com: 'inserted comments'
        },
        insert: {
          progress_step_id: @step.id,
          completed: true,
          completed_on: Time.now,
          comments: 'inserted comments'
        },
        update: {
        completed: false,
        completed_on: Time.now - 1.day,
        comments: 'update comments'
        }
      }

      # reset session variables @TRIGGER_CHECKS_CHEMFIL1
      ActiveRecord::Base.connection.reset!
    end

    test 'insert formula progress step' do
      formula = Formula.first
      formula_progress_step = formula.formulas_progress_steps.create!(@data[:insert])
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql(formula.code), as: :hash)

      assert_equal 1, r.count
      assert_equal @data[:insert][:completed], (r.first[@step.code+'_YN'] == 1)
      assert_equal @data[:insert][:completed_on].to_s, r.first[@step.code+'_Date'].to_s
      assert_equal @data[:insert][:comments], r.first[@step.code+'_Com']
    end

    test 'update formula progress step' do
      insert_sql.each {|sql| ActiveRecord::Base.connection.execute(sql)}
      ActiveRecord::Base.connection.reset!

      formula = Formula.find_by_code!(@data[:insert_sync][:code])
      formula_progress_step = formula.formulas_progress_steps.first

      formula_progress_step.update_attributes!(@data[:update])
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql(formula.code), as: :hash)

      assert_equal 1, r.count
      assert_equal @data[:update][:completed], (r.first[@step.code+'_YN'] == 1)
      assert_equal @data[:update][:completed_on].to_s, r.first[@step.code+'_Date'].to_s
      assert_equal @data[:update][:comments], r.first[@step.code+'_Com']
    end

    test 'delete formula progress step' do
      insert_sql.each {|sql| ActiveRecord::Base.connection.execute(sql)}
      ActiveRecord::Base.connection.reset!

      formula = Formula.find_by_code!(@data[:insert_sync][:code])
      formula_progress_step = formula.formulas_progress_steps.first

      formula_progress_step.destroy
      r = ActiveRecord::Base.connection.raw_connection.query(select_sql(formula.code), as: :hash)

      assert_equal 1, r.count
      assert_equal 0, r.first[@step.code+'_YN']
      assert_equal nil, r.first[@step.code+'_Date']
      assert_equal nil, r.first[@step.code+'_Com']
    end

    private

    def select_sql(product_code)
      <<-SQL
        SELECT *
        FROM chemfil1_test.new_product_progress_data
        WHERE `Product Code` = "#{product_code}";
      SQL
    end

    def insert_sql
      sql1 = <<-SQL
        INSERT INTO chemfil1_test.new_product_progress_data
          (`Product Code`, `Product Name`, `Status`, `Sales to Date`, `Sr_Mgmt_Rev_BY`,
          `Cust_Req_YN`, `Cust_Req_Date`, `Cust_Req_Com`)
        VALUES (
          "#{@data[:insert_sync][:code]}",
          "#{@data[:insert_sync][:name]}",
          "#{@data[:insert_sync][:state]}",
          "#{@data[:insert_sync][:sales_to_date]}",
          "#{@data[:insert_sync][:reviewed_by]}",
          "#{@data[:insert_sync][:cust_req_yn]}",
          "#{@data[:insert_sync][:cust_req_date]}",
          "#{@data[:insert_sync][:cust_req_com]}"
        );
      SQL
      sql2 = <<-SQL
        INSERT INTO chemfil1_test.new_product_progress_data_comments
          (`Product Code`, `Comments`)
        VALUES (
          "#{@data[:insert_sync][:code]}",
          "#{@data[:insert_sync][:comments]}"
        );
      SQL

      [sql1, sql2]
    end

  end
end
