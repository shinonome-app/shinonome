# frozen_string_literal: true

Worker.connection.execute('TRUNCATE TABLE workers;')
100.times do |i|
  n = i + 1
  sortkey = %w[あ か さ た な は ま や ら わ].sample
  name = Gimei.name
  Worker.create!(name: name.kanji,
                 email: "aozora-worker#{n}@example.com",
                 name_kana: name.hiragana,
                 note: "備考#{n}",
                 sortkey: name.hiragana,
                 url: "https://www.aozora.gr.jp/dummy/workers/#{n}")
end
