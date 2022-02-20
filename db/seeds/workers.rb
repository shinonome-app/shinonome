# frozen_string_literal: true

# Worker.connection.execute('TRUNCATE TABLE workers;')
user_id_list = Shinonome::User.all.pluck(:id)

workers = (1..1200).map do |n|
  name = Gimei.name

  {
    name: name.kanji,
    email: "shinonome-worker#{n}@example.com",
    name_kana: name.hiragana,
    note: "備考#{n}",
    sortkey: name.hiragana,
    url: "https://shinonome.example.com/dummy/workers/#{n}",
    user_id: user_id_list.sample,
    created_at: Time.current,
    updated_at: Time.current
  }
end

Worker.insert_all(workers)
