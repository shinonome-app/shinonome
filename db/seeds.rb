kana_types = {
  1 => '旧字旧仮名',
  2 =>	'旧字新仮名',
  3 =>	'新字旧仮名',
  4 =>	'新字新仮名',
  99 =>	'その他'
}

KanaType.connection.execute('TRUNCATE TABLE kana_types;')
kana_types.each do |k, v|
  KanaType.create!(id: k, name: v)
end

charsets = {
  1	=> 'JIS X 0208',
  2	=>	'JIS X 0213',
  3	=>	'Unicode',
  99	=> 'その他'
}

Charset.connection.execute('TRUNCATE TABLE charsets;')
charsets.each do |k, v|
  Charset.create!(id: k, name: v)
end

filetypes = {
  0 => %w[入力完了ファイル txt],
  1 => %w[テキストファイル(ルビあり) rtxt],
  2 => %w[テキストファイル(ルビなし) txt],
  3 => %w[HTMLファイル html],
  4 => %w[エキスパンドブックファイル ebk],
  5 => %w[.bookファイル book],
  6 => %w[TTZファイル ttz],
  7 => %w[PDFファイル pdf],
  8 => %w[PalmDocファイル doc],
  9 => %w[XHTMLファイル html],
  99 => %w[その他 etc]
}

Filetype.connection.execute('TRUNCATE TABLE filetypes;')
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

Compresstype.connection.execute('TRUNCATE TABLE compresstypes;')
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

FileEncoding.connection.execute('TRUNCATE TABLE file_encodings;')
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

Role.connection.execute('TRUNCATE TABLE roles;')
roles.each do |k, v|
  Role.create!(id: k, name: v)
end

worker_roles = {
  1 => '入力者',
  2 => '校正者',
  99 => 'その他'
}

WorkerRole.connection.execute('TRUNCATE TABLE worker_roles;')
worker_roles.each do |k, v|
  WorkerRole.create!(id: k, name: v)
end

require_relative "seeds/workers"
