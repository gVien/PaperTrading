# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!({ first_name: "Gai ",
               last_name: "V",
               email: ENV["GAI_EMAIL"],
               password: ENV["PASSWORD"],
               password_confirmation: ENV["PASSWORD"],
               admin: true,
               activated: true,
               activated_at: Time.zone.now,
               activation_email_sent_at: 1.hour.ago })

# for testing/development
99.times do |n|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = "user#{n}@example.com"
  password = "123456"
  User.create!({ first_name: first_name,
                 last_name: last_name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 activated: true,
                 activated_at: Time.zone.now,
                 activation_email_sent_at: 1.hour.ago })
end

users = User.order(:created_at).take(10)
50.times do
  content = Faker::Lorem.sentence(10)
  users.each { |user| user.posts.create!(content: content) }
end

# followers/following
user = User.first
users = User.all
followers = users[2..60]
following = users[2..80]
followers.each { |follower| follower.follow(user) }
following.each { |followed| user.follow(followed) }
