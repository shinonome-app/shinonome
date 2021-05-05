# frozen_string_literal: true

User.connection.execute('TRUNCATE TABLE users;')
User.create!(username: 'admin',
             email: 'admin@example.com',
             password: 'shinonome')
10.times do |i|
  n = i + 1
  User.create!(username: "user#{n}",
               email: "shinonome-user#{n}@example.com",
               password: "shinonome-pass#{n}")
end
