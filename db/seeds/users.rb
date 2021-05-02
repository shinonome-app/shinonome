# frozen_string_literal: true

User.connection.execute('TRUNCATE TABLE users;')
10.times do |i|
  User.create!(email: "aozora-user#{i}@example.com",
               password: "aozora-pass#{i}")
end
