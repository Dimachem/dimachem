namespace :seed_data do
  namespace :users do
    desc "seed data for users"
    task insert_development: :environment do
      users =[ User.new(username: 'dev_user')]
      puts "Start inserting #{users.count} user(s)"

      ActiveRecord::Base.transaction do
        users.each do |user|
          user.save!
          print "."
        end
      end

      puts " Finished inserting #{users.count} user(s)"
    end
  end
end
