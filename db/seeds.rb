# frozen_string_literal: true

kana_types = {
  1 => '旧字旧仮名',
  2 => '旧字新仮名',
  3 => '新字旧仮名',
  4 => '新字新仮名',
  99 => 'その他'
}

# exist successfully if already created
if KanaType.count.positive?
  warn 'Seeds have already been created.'
  return
end

# KanaType.connection.execute('TRUNCATE TABLE kana_types;')
kana_types.each do |k, v|
  KanaType.create!(id: k, name: v)
end

charsets = {
  1 => 'JIS X 0208',
  2 => 'JIS X 0213',
  3 => 'Unicode',
  99 => 'その他'
}

# Charset.connection.execute('TRUNCATE TABLE charsets;')
charsets.each do |k, v|
  Charset.create!(id: k, name: v)
end

filetypes = {
  0 => %w[入力完了ファイル txt],
  1 => %w[テキストファイル(ルビあり) rtxt],
  2 => %w[テキストファイル(ルビなし) txt],
  3 => %w[HTMLファイル html],
  4 => %w[エキスパンドブックファイル ebk],
  5 => %w[.workファイル work],
  6 => %w[TTZファイル ttz],
  7 => %w[PDFファイル pdf],
  8 => %w[PalmDocファイル doc],
  9 => %w[XHTMLファイル html],
  99 => %w[その他 etc]
}

# Filetype.connection.execute('TRUNCATE TABLE filetypes;')
filetypes.each do |k, v|
  Filetype.create!(id: k, name: v[0], extension: v[1])
end

compresstypes = {
  1 => %w[圧縮なし none],
  2 => %w[ZIP圧縮 zip],
  3 => %w[GZIP圧縮 gz],
  4 => %w[LHA圧縮 lzh],
  5 => %w[SIT圧縮 sit]
}

# Compresstype.connection.execute('TRUNCATE TABLE compresstypes;')
compresstypes.each do |k, v|
  Compresstype.create!(id: k, name: v[0], extension: v[1])
end

file_encodings = {
  1 => 'ShiftJIS',
  2 => 'JIS',
  3 => 'EUC',
  4 => 'UTF-8',
  99 => 'その他'
}

# FileEncoding.connection.execute('TRUNCATE TABLE file_encodings;')
file_encodings.each do |k, v|
  FileEncoding.create!(id: k, name: v)
end

roles = {
  1 => '著者',
  2 => '翻訳者',
  3 => '校訂者',
  4 => '編者',
  99 => 'その他'
}

# Role.connection.execute('TRUNCATE TABLE roles;')
roles.each do |k, v|
  Role.create!(id: k, name: v)
end

worker_roles = {
  1 => '入力者',
  2 => '校正者',
  99 => 'その他'
}

# WorkerRole.connection.execute('TRUNCATE TABLE worker_roles;')
worker_roles.each do |k, v|
  WorkerRole.create!(id: k, name: v)
end

work_statuses = <<~ROWS
  1	公開	1
  2	非公開	2
  3	入力中	3
  4	入力予約	4
  5	校正待ち(点検済み)	5
  6	校正待ち(点検前)	6
  7	校正予約(点検済み)	7
  8	校正予約(点検前)	8
  9	校正中	9
  10	校了	10
  11	翻訳中	11
  12	入力取り消し	12
ROWS

# WorkStatus.connection.execute('TRUNCATE TABLE work_statuses;')
work_statuses.each_line do |line|
  rows = line.chomp.split
  WorkStatus.create!(id: rows[0].to_i, name: rows[1], sort_order: rows[2].to_i)
end

booktypes = {
  1 => '底本',
  2 => '底本の親本'
}

# Booktype.connection.execute('TRUNCATE TABLE booktypes;')
booktypes.each do |k, v|
  Booktype.create!(id: k, name: v)
end

## 人物（著者なし）を追加
Person.create(id: 0,
              last_name: '著者なし',
              last_name_kana: 'ちょしゃなし',
              last_name_en: 'Choshanashi',
              copyright_flag: false,
              sortkey: 'ちょしゃなし')
## 予備工作員を追加
worker_dummy = Worker.create(id: 0,
                             name: '予備工作員',
                             name_kana: 'よびこうさくいん',
                             sortkey: 'よびこうさくいん')
WorkerSecret.create(
  worker_id: worker_dummy.id,
  email: 'shinonome-worker0@example.com',
  note: '予備工作員用',
  url: 'https://shinonome.example.com/dummy/workers/0'
)

if Rails.env.development? || ENV.fetch('USE_ALL_SEEDS', nil)
  require_relative 'seeds/users'
  require_relative 'seeds/news_entries'
  require_relative 'seeds/workers'
  require_relative 'seeds/people'
  require_relative 'seeds/receipts'
  require_relative 'seeds/works'
  require_relative 'seeds/sites'
  require_relative 'seeds/workfiles'
end
