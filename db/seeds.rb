# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Rake::Task['seed_data:progress_steps:insert'].invoke
Rake::Task['seed_data:roles:insert'].invoke
Rake::Task['seed_data:users:insert'].invoke
