# frozen_string_literal: true

# Site.connection.execute('TRUNCATE TABLE sites;')
# Site.connection.execute('TRUNCATE TABLE work_sites;')
selected_works = Work.order(:id).limit(100)

100.times do |i|
  n = i + 1
  site = Site.create!(name: "関連サイト#{n}",
                      email: "shinonome-site#{n}@example.com",
                      owner_name: "運営者#{n}",
                      url: "https://shinonome.example.com/sites/#{n}",
                      note: "備考#{n}")
  work = selected_works.sample
  sb = site.work_sites.build(work: work)
  sb.save!
end
