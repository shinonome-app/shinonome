# frozen_string_literal: true

Site.connection.execute('TRUNCATE TABLE sites;')
100.times do |i|
  n = i + 1
  Site.create!(name: "関連サイト#{n}",
               email: "aozora-site#{n}@example.com",
               owner_name: "運営者#{n}",
               url: "https://example.com/sites/#{n}",
               note: "備考#{n}")
end
