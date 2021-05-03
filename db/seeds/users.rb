# frozen_string_literal: true

User.connection.execute('TRUNCATE TABLE users;')
10.times do |i|
  n = i + 1
  User.create!(username: "user#{n}",
               email: "aozora-user#{n}@example.com",
               password: "aozora-pass#{n}")
end
