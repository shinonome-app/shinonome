# frozen_string_literal: true

Site.connection.execute('TRUNCATE TABLE sites;')
Site.connection.execute('TRUNCATE TABLE book_sites;')
selected_books = Book.order(:id).limit(100)

100.times do |i|
  n = i + 1
  site = Site.create!(name: "関連サイト#{n}",
                      email: "shinonome-site#{n}@example.com",
                      owner_name: "運営者#{n}",
                      url: "https://shinonome.example.com/sites/#{n}",
                      note: "備考#{n}")
  book = selected_books.sample
  sb = site.book_sites.build(book: book)
  sb.save!
end
