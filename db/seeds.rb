# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Run 'rake db:seed' from terminal to create an Admin User in your database

superadmin = User.new(email: 'superadmin@ibdb.com',
                      password: 'password', password_confirmation: 'password')

superadmin.toggle!(:superadmin)

if superadmin.valid?
  superadmin.save

elsif superadmin.errors.any?
  superadmin.errors.full_messages.each do |msg|
    puts msg
  end
else
  puts '****NOT VALID****'
end
