# frozen_string_literal: true

Worker.connection.execute('TRUNCATE TABLE workers;')
100.times do |i|
  n = i + 1
  sortkey = %w[あ か さ た な は ま や ら わ].sample
  Worker.create!(name: "#{sortkey}工作員#{n}",
                 email: "aozora-worker#{n}@example.com",
                 name_kana: "#{sortkey}こうさくいん#{n}",
                 note: "備考#{n}",
                 sortkey: sortkey,
                 url: "https://www.aozora.gr.jp/dummy/workers/#{n}")
end
