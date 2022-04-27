# frozen_string_literal: true

# Worker.connection.execute('TRUNCATE TABLE workers;')
# user_id_list = Shinonome::User.all.pluck(:id)
user_id_list = (1..10).to_a

workers = (1..1200).map do |_n|
  name = Gimei.name

  {
    name: name.kanji,
    name_kana: name.hiragana,
    sortkey: name.hiragana,
    created_at: Time.current,
    updated_at: Time.current
  }
end

items = Worker.insert_all(workers, returning: %w[id])

worker_secrets = items.map do |item|
  n = item['id']

  {
    worker_id: n,
    email: "shinonome-worker#{n}@example.com",
    note: "備考#{n}",
    url: "https://shinonome.example.com/dummy/workers/#{n}",
    user_id: user_id_list.sample,
    created_at: Time.current,
    updated_at: Time.current
  }
end

WorkerSecret.insert_all(worker_secrets)
