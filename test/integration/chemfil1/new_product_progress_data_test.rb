require 'test_helper'

module Integration
  module Chemfil1
    class NewProductProgressDataTest < ActiveSupport::TestCase

      def setup
        @data = {
          insert: {
            code: SecureRandom.uuid,
            name: 'inserted name',
            state: 'inserted status',
            comments: 'inserted comments',
            reviewed_by: 'insert reviewer',
            tds_msds_yn: 0,
            tds_msds_date: '2015-07-11 16:00:09',
            tds_msds_com: 'insert tds comment'
          },
          update: {
            code: SecureRandom.uuid,
            name: 'updated name',
            state: 'updated status',
            comments: 'updated comments',
            reviewed_by: 'updated reviewer',
            tds_msds_yn: 1,
            tds_msds_date: '2016-07-11 16:00:09',
            tds_msds_com: nil,
            formula_yn: 0,
            formula_date: nil,
            formula_com: 'updated Formula comment',
            test_proc_rec_yn: 1,
            test_proc_rec_date: '2016-07-13 16:00:09',
            test_proc_rec_com: 'updated test_proc_rec comment',
            prod_spec_yn: 0,
            prod_spec_date: '2016-07-16 16:00:09',
            prod_spec_com: 'updated prod_spec comment',
            form_to_purch_mang_yn: 1,
            form_to_purch_mang_date: '2016-07-19 16:00:09',
            form_to_purch_mang_com: 'updated form_to_purch_mang comment'
          }
        }

        # reset session variables @TRIGGER_CHECKS_DIMACHEM
        ActiveRecord::Base.connection.reset!
      end

      test 'insert new product progress data' do
        ActiveRecord::Base.connection.execute(insert_sql)
        formula = Formula.find_by_code(@data[:insert][:code])

        assert_equal(@data[:insert][:code], formula.code)
        assert_equal(Date.today, formula.created_at.to_date)
        assert_equal(Date.today, formula.updated_at.to_date)
      end

      test 'update new product progress data' do
        ActiveRecord::Base.connection.execute(insert_sql)
        ActiveRecord::Base.connection.reset!
        org_formula = Formula.find_by_code(@data[:insert][:code])
        sleep(1)

        sql = <<-SQL
          UPDATE chemfil1_test.new_product_progress_data
            SET `Product Code` = "#{@data[:update][:code]}",
                `Product Name` = "#{@data[:update][:name]}",
                `Status` = "#{@data[:update][:state]}",
                `Comments` = "#{@data[:update][:comments]}"
          WHERE `Product Code` = "#{@data[:insert][:code]}"
        SQL

        ActiveRecord::Base.connection.execute(sql)
        formula = Formula.find_by_code(@data[:update][:code])

        assert_equal(@data[:update][:code], formula.code)
        assert_equal(@data[:update][:name], formula.name)
        assert_equal(@data[:update][:state], formula.state)
        assert_equal(@data[:update][:comments], formula.comments)
        assert_equal(org_formula.created_at, formula.created_at)
        assert(org_formula.updated_at < formula.updated_at)
      end

      test 'update one new product progress steps' do
        ActiveRecord::Base.connection.execute(insert_sql)
        ActiveRecord::Base.connection.reset!

        sql = update_sql(['tds_msds_'])

        ActiveRecord::Base.connection.execute(sql)
        formula = Formula.find_by_code(@data[:insert][:code])
        formulas_progress_step = formula.formulas_progress_steps.first

        assert_equal((@data[:update][:tds_msds_yn] == 1), formulas_progress_step.completed)
        assert_equal(try_parse_datetime(@data[:update][:tds_msds_date]), formulas_progress_step.completed_on)
        assert_equal(@data[:insert][:tds_msds_com], formulas_progress_step.comments)
      end

      test 'update many new product progress steps' do
        steps = ['tds_msds_', 'formula_', 'test_proc_rec_', 'prod_spec_', 'form_to_purch_mang_']
        ActiveRecord::Base.connection.execute(insert_sql)
        ActiveRecord::Base.connection.reset!

        sql = update_sql(steps)

        ActiveRecord::Base.connection.execute(sql)
        formula = Formula.find_by_code(@data[:insert][:code])
        formulas_progress_steps = formula.formulas_progress_steps

        steps.each_with_index do |step, i|
          assert_equal((@data[:update][(step+'yn').to_sym] == 1), formulas_progress_steps[i].completed)
          assert_equal(try_parse_datetime(@data[:update][(step+'date').to_sym]), formulas_progress_steps[i].completed_on)
          expected_com = @data[:update][(step+'com').to_sym] || @data[:insert][(step+'com').to_sym]
          assert_equal(expected_com, formulas_progress_steps[i].comments)
        end
      end

      test 'delete new product progress data' do
        ActiveRecord::Base.connection.execute(insert_sql)
        ActiveRecord::Base.connection.reset!

        sql = <<-SQL
          DELETE FROM chemfil1_test.new_product_progress_data
          WHERE `Product Code` = "#{@data[:insert][:code]}"
        SQL

        ActiveRecord::Base.connection.execute(sql)

        assert_raises(ActiveRecord::RecordNotFound) {
          Formula.find_by_code!(@data[:insert][:code])
        }
      end

      private

      def try_parse_datetime(s)
        ::DateTime.parse(s)
      rescue TypeError
        nil
      end

      def update_sql(step_codes)
        set_statments = step_codes.map do |step_code|
          sets = []
          sets << "`#{step_code.titleize}YN` = \"#{@data[:update][(step_code + 'yn').to_sym]}\"" if @data[:update][(step_code + 'yn').to_sym].present?
          sets << "`#{step_code.titleize}Date` = \"#{@data[:update][(step_code + 'date').to_sym]}\"" if @data[:update][(step_code + 'date').to_sym].present?
          sets << "`#{step_code.titleize}Com` = \"#{@data[:update][(step_code + 'com').to_sym]}\"" if @data[:update][(step_code + 'com').to_sym].present?
          sets.join(', ')
        end

        <<-SQL
          UPDATE chemfil1_test.new_product_progress_data
            SET #{set_statments.join(', ')}
          WHERE `Product Code` = "#{@data[:insert][:code]}"
        SQL
      end

      def insert_sql
        sql = <<-SQL
          INSERT INTO chemfil1_test.new_product_progress_data
            (`Product Code`, `Product Name`, `Status`, `Comments`, `Sr_Mgmt_Rev_BY`,
            `TDS MSDS YN`, `TDS MSDS Date`, `TDS MSDS Com`)
          VALUES (
            "#{@data[:insert][:code]}",
            "#{@data[:insert][:name]}",
            "#{@data[:insert][:state]}",
            "#{@data[:insert][:comments]}",
            "#{@data[:insert][:reviewed_by]}",
            "#{@data[:insert][:tds_msds_yn]}",
            "#{@data[:insert][:tds_msds_date]}",
            "#{@data[:insert][:tds_msds_com]}"
          )
        SQL
      end

    end
  end
end
