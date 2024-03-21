# frozen_string_literal: true

# Site.connection.execute('TRUNCATE TABLE sites;')
# Site.connection.execute('TRUNCATE TABLE work_sites;')
selected_works = Work.order(:id).limit(100)

user = Shinonome::User.last
100.times do |i|
  n = i + 1
  site = Site.create!(name: "関連サイト#{n}",
                      url: "https://shinonome.example.com/sites/#{n}",
                      updated_by: user.id)
  site.create_site_secret!(
    email: "shinonome-site#{n}@example.com",
    owner_name: "運営者#{n}",
    memo: "備考#{n}"
  )
  work = selected_works.sample
  sb = site.work_sites.build(work:)
  sb.save!
end
