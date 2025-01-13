# frozen_string_literal: true

ApplicationRecord.transaction do
  # rubocop:disable Rails/SkipsModelValidations
  kana_types = [
    { id: 1, name: '旧字旧仮名' },
    { id: 2, name: '旧字新仮名' },
    { id: 3, name: '新字旧仮名' },
    { id: 4, name: '新字新仮名' },
    { id: 99, name: 'その他' }
  ]

  KanaType.upsert_all(kana_types)

  charsets = [
    { id: 1, name: 'JIS X 0208' },
    { id: 2, name: 'JIS X 0213' },
    { id: 3, name: 'Unicode' },
    { id: 99, name: 'その他' }
  ]

  Charset.upsert_all(charsets)

  filetypes = [
    { id: 0, name: '入力完了ファイル', extension: 'txt', is_html: false, is_text: true, is_rtxt: false },
    { id: 1, name: 'テキストファイル(ルビあり)', extension: 'rtxt', is_html: false, is_text: true, is_rtxt: true },
    { id: 2, name: 'テキストファイル(ルビなし)', extension: 'txt', is_html: false, is_text: true, is_rtxt: false },
    { id: 3, name: 'HTMLファイル', extension: 'html', is_html: true, is_text: false, is_rtxt: false },
    { id: 4, name: 'エキスパンドブックファイル', extension: 'ebk', is_html: false, is_text: false, is_rtxt: false },
    { id: 5, name: '.workファイル', extension: 'work', is_html: false, is_text: false, is_rtxt: false },
    { id: 6, name: 'TTZファイル', extension: 'ttz', is_html: false, is_text: false, is_rtxt: false },
    { id: 7, name: 'PDFファイル', extension: 'pdf', is_html: false, is_text: false, is_rtxt: false },
    { id: 8, name: 'PalmDocファイル', extension: 'doc', is_html: false, is_text: false, is_rtxt: false },
    { id: 9, name: 'XHTMLファイル', extension: 'html', is_html: true, is_text: false, is_rtxt: false },
    { id: 10, name: 'EPUBファイル', extension: 'epub', is_html: false, is_text: false, is_rtxt: false },
    { id: 99, name: 'その他', extension: 'etc', is_html: false, is_text: false, is_rtxt: false }
  ]
  Filetype.upsert_all(filetypes)

  compresstypes = [
    { id: 1, name: '圧縮なし', extension: 'none' },
    { id: 2, name: 'ZIP圧縮', extension: 'zip' },
    { id: 3, name: 'GZIP圧縮', extension: 'gz' },
    { id: 4, name: 'LHA圧縮', extension: 'lzh' },
    { id: 5, name: 'SIT圧縮', extension: 'sit' }
  ]

  Compresstype.upsert_all(compresstypes)

  file_encodings = [
    { id: 1, name: 'ShiftJIS' },
    { id: 2, name: 'JIS' },
    { id: 3, name: 'EUC' },
    { id: 4, name: 'UTF-8' },
    { id: 99, name: 'その他' }
  ]

  FileEncoding.upsert_all(file_encodings)

  roles = [
    { id: 1, name: '著者' },
    { id: 2, name: '翻訳者' },
    { id: 3, name: '校訂者' },
    { id: 4, name: '編者' },
    { id: 5, name: '監修者' },
    { id: 99, name: 'その他' }
  ]

  Role.upsert_all(roles)

  worker_roles = [
    { id: 1, name: '入力者' },
    { id: 2, name: '校正者' },
    { id: 99, name: 'その他' }
  ]

  WorkerRole.upsert_all(worker_roles)

  work_statuses = [
    { id: 1, name: '公開', sort_order: 1 },
    { id: 2, name: '非公開', sort_order: 2 },
    { id: 3, name: '入力中', sort_order: 3 },
    { id: 4, name: '入力予約', sort_order: 4 },
    { id: 5, name: '校正待ち(点検済み)', sort_order: 5 },
    { id: 6, name: '校正待ち(点検前)', sort_order: 6 },
    { id: 7, name: '校正予約(点検済み)', sort_order: 7 },
    { id: 8, name: '校正予約(点検前)', sort_order: 8 },
    { id: 9, name: '校正中', sort_order: 9 },
    { id: 10, name: '校了', sort_order: 10 },
    { id: 11, name: '翻訳中', sort_order: 11 },
    { id: 12, name: '入力取り消し', sort_order: 12 },
    { id: 13, name: '校了（点検前）', sort_order: 13 },
    { id: 14, name: '校正受領', sort_order: 14 },
    { id: 15, name: '公開保留', sort_order: 15 }
  ]

  WorkStatus.upsert_all(work_statuses)

  booktypes = [
    { id: 1, name: '底本' },
    { id: 2, name: '底本の親本' }
  ]

  Booktype.upsert_all(booktypes)

  ## 人物（著者なし）を追加
  Person.upsert({ id: 0,
                  last_name: '著者なし',
                  last_name_kana: 'ちょしゃなし',
                  last_name_en: 'Choshanashi',
                  copyright_flag: false,
                  sortkey: 'ちょしゃなし' })
  ## 予備工作員を追加
  Worker.upsert({ id: 0,
                  name: '予備工作員',
                  name_kana: 'よびこうさくいん',
                  sortkey: 'よびこうさくいん' })
  Shinonome::WorkerSecret.upsert(
    { id: 0,
      worker_id: 0,
      email: 'shinonome-worker0@example.com',
      note: '予備工作員用',
      url: 'https://shinonome.example.com/dummy/workers/0' }
  )

  editable_contents = [
    {
      id: 0,
      area_name: 'top',
      key: 'main',
      value: Rails.root.join('db/seeds/texts/top_template.txt').read
    }
  ]

  EditableContent.upsert_all(editable_contents)

  # rubocop:enable Rails/SkipsModelValidations
end

if Rails.env.development? || ENV.fetch('DISABLE_DATABASE_ENVIRONMENT_CHECK', nil) || ENV.fetch('USE_ALL_SEEDS', nil)
  require_relative 'seeds/users'
  require_relative 'seeds/news_entries'
  require_relative 'seeds/workers'
  require_relative 'seeds/people'
  require_relative 'seeds/receipts'
  require_relative 'seeds/works'
  require_relative 'seeds/sites'
  require_relative 'seeds/workfiles'
end
