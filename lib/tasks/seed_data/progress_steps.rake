namespace :seed_data do
  namespace :progress_steps do
    desc "seed data for progress_steps"
    task insert: :environment do
      progress_steps = [
        {code: 'Cust_Req', position: 1, description: 'Obtain, review and address requirements', effective_on: Time.now},
        {code: 'Cust_Specs', position: 2, description: 'Obtain, review and address specifications', effective_on: Time.now},
        {code: 'TDS MSDS', position: 3, description: 'Retrieve MSDS/TDS', effective_on: Time.now},
        {code: 'Formula', position: 4, description: 'Formula provided and stored', effective_on: Time.now},
        {code: 'Disc Nature-Duration-Complexity', position: 5, description: 'Discuss nature, duration and complexity of design', effective_on: Time.new(2016, 04, 01)},
        {code: 'Disc Consequences of Failure', position: 6, description: 'Discuss consequences of failure', effective_on: Time.now},
        {code: 'Test Proc Rec', position: 7, description: 'Retrieve test procedures as required', effective_on: Time.now},
        {code: 'Prod Spec', position: 8, description: 'Retrieve product specifications', effective_on: Time.now},
        {code: 'OK on Raws', position: 9, description: 'Ok rec\'d from QC/Purchasing (CEPA Status)', effective_on: Time.now},
        {code: 'Prod Code Entered', position: 10, description: 'Product Code entered into system', effective_on: Time.now},
        {code: 'MSDS Init', position: 11, description: 'MSDS\' for raws in system, finished MSDS setup', effective_on: Time.now},
        {code: 'Lab Batch', position: 12, description: 'Lab Batch completed', effective_on: Time.now},
        {code: 'QC Tests Entered', position: 13, description: 'QC Tests entered into system', effective_on: Time.now},
        {code: 'Formula Entered', position: 14, description: 'Formula entered into system', effective_on: Time.now},
        {code: 'MOC', position: 15, description: 'Manufacturing MOC considered?', effective_on: Time.now},
        {code: 'Env_Aspects', position: 16, description: 'Environmental Impacts/Aspects considered?', effective_on: Time.now},
        {code: 'Sr_Mgmt_Rev', position: 17, description: 'Senior Management Review Completed', effective_on: Time.now},
        {code: 'Form to Purch Mang', position: 18, description: 'N/A 1', effective_on: Time.now-2.days, effective_until: Time.now-1.day},
        {code: 'Test proc Forw', position: 19, description: 'N/A 2', effective_on: Time.now-2.days, effective_until: Time.now-1.day}
      ]

      puts "Start inserting #{progress_steps.count} progress_step(s)"

      ActiveRecord::Base.transaction do
        progress_steps.each do |progress_step|
          ProgressStep.create!(progress_step)
          print "."
        end
      end

      puts " Finished inserting #{progress_steps.count} progress_step(s)"
    end
  end
end
