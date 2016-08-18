# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

progress_steps = [
  {code: 'Cust_Req', position: 1, description: 'Obtain, review and address requirements', effective_on: Time.now},
  {code: 'Cust_Specs', position: 1, description: 'Obtain, review and address specifications', effective_on: Time.now},
  {code: 'TDS MSDS', position: 1, description: 'Retrieve MSDS/TDS', effective_on: Time.now},
  {code: 'Formula', position: 1, description: 'Formula provided and stored', effective_on: Time.now},
  {code: 'Disc Nature-Duration-Complexity', position: 1, description: 'Discuss nature, duration and complexity of design', effective_on: Time.new(2016, 04, 01)},
  {code: 'Disc Consequences of Failure', position: 1, description: 'Discuss consequences of failure', effective_on: Time.now},
  {code: 'Test Proc Rec', position: 1, description: 'Retrieve test procedures as required', effective_on: Time.now},
  {code: 'Prod Spec', position: 1, description: 'Retrieve product specifications', effective_on: Time.now},
  {code: 'OK on Raws', position: 1, description: 'Ok rec\'d from QC/Purchasing (CEPA Status)', effective_on: Time.now},
  {code: 'Prod Code Entered', position: 1, description: 'Product Code entered into system', effective_on: Time.now},
  {code: 'MSDS Init', position: 1, description: 'MSDS\' for raws in system, finished MSDS setup', effective_on: Time.now},
  {code: 'Lab Batch', position: 1, description: 'Lab Batch completed', effective_on: Time.now},
  {code: 'QC Tests Entered', position: 1, description: 'QC Tests entered into system', effective_on: Time.now},
  {code: 'Formula Entered', position: 1, description: 'Formula entered into system', effective_on: Time.now},
  {code: 'MOC', position: 1, description: 'Manufacturing MOC considered?', effective_on: Time.now},
  {code: 'Env_Aspects', position: 1, description: 'Environmental Impacts/Aspects considered?', effective_on: Time.now},
  {code: 'Sr_Mgmt_Rev', position: 1, description: 'Senior Management Review Completed', effective_on: Time.now},
  {code: 'Form to Purch Mang', position: 1, description: 'N/A 1', effective_on: Time.now},
  {code: 'Test proc Forw', position: 1, description: 'N/A 2', effective_on: Time.now}
]
ProgressStep.create!(progress_steps)

User.create!(username: 'dev_user')
