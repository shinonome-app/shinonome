# frozen_string_literal: true

# Shinonome::User.connection.execute('TRUNCATE TABLE users;')
Shinonome::User.create!(username: 'admin',
                        email: 'admin@example.com',
                        password: 'shinonome')
10.times do |i|
  n = i + 1
  Shinonome::User.create!(username: "user#{n}",
                          email: "shinonome-user#{n}@example.com",
                          password: "shinonome-pass#{n}")
end
