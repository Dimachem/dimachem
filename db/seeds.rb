# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

progress_steps = [
  {code: 'Cust_Req_', description: 'Obtain, review and address requirements', effective_on: Time.now},
  {code: 'Cust_Specs_', description: 'Obtain, review and address specifications', effective_on: Time.now},
  {code: 'TDS MSDS ', description: 'Retreive MSDS/TDS', effective_on: Time.now},
  {code: 'Formula ', description: 'Formula provided and stored', effective_on: Time.now},
  {code: 'Disc Nature-Duration-Complexity ', description: 'Discuss nature, duration and complexity of design', effective_on: Time.new(2016, 04, 01)},
  {code: 'Disc Consequences of Failure ', description: 'Discuss consequences of failure', effective_on: Time.now},
  {code: 'Test Proc Rec ', description: 'Retreive test procedures as required', effective_on: Time.now},
  {code: 'Prod Spec ', description: 'Retreive product specifications', effective_on: Time.now},
  {code: 'OK on Raws ', description: 'Ok rec\'d from QC/Purchasing (CEPA Status)', effective_on: Time.now},
  {code: 'Prod Code Entered ', description: 'Product Code entered into system', effective_on: Time.now},
  {code: 'MSDS Init ', description: 'MSDS\' for raws in system, finished MSDS setup', effective_on: Time.now},
  {code: 'Lab Batch ', description: 'Lab Batch completed', effective_on: Time.now},
  {code: 'QC Tests Entered ', description: 'QC Tests entered into system', effective_on: Time.now},
  {code: 'Formula Entered ', description: 'Formula entered into system', effective_on: Time.now},
  {code: 'MOC ', description: 'Manufacturing MOC considered?', effective_on: Time.now},
  {code: 'Env_Aspects_', description: 'Environmental Impacts/Aspects considered?', effective_on: Time.now},
  {code: 'Sr_Mgmt_Rev_', description: 'Senior Management Review Completed', effective_on: Time.now},
  {code: 'Form to Purch Mang ', description: 'N/A 1', effective_on: Time.now},
  {code: 'Test proc Forw ', description: 'N/A 2', effective_on: Time.now}
]
ProgressStep.create(progress_steps)
