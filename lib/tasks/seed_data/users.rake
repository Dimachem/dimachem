namespace :seed_data do
  namespace :users do
    desc "seed data for users"
    task insert: :environment do
      users =[
        {username: 'dev_user', role: :super_user}
      ]
      puts "Start inserting #{users.count} user(s)"

      ActiveRecord::Base.transaction do
        users.each do |attrs|
          role = attrs.delete(:role)
          user = User.create!(attrs)
          user.add_role(role) if role
          print "."
        end
      end

      puts " Finished inserting #{users.count} user(s)"
    end
  end
end
