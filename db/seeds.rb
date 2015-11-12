# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!({ first_name: "Gai",
               last_name: "V",
               email: "gai@gai.com",
               password: "123456",
               password_confirmation: "123456",
               admin: true })

99.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "user#{n}@example.com"
  password = "123456"
  User.create!({ first_name: first_name,
                 last_name: last_name,
                 email: email,
                 password: password,
                 password_confirmation: password })
end

