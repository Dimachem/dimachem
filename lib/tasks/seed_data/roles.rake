namespace :seed_data do
  namespace :roles do
    desc "seed data for roles"
    task insert: :environment do
      roles =[
        {name: 'super_user'},
        {name: 'administrator'},
        {name: 'formula_management'},
        {name: 'laboratory'}
      ]
      puts "Start inserting #{roles.count} user(s)"

      ActiveRecord::Base.transaction do
        roles.each do |attrs|
          user = Role.create!(attrs)
          print "."
        end
      end

      puts " Finished inserting #{roles.count} user(s)"
    end
  end
end
