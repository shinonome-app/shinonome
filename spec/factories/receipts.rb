# == Schema Information
#
# Table name: receipts
#
#  id                 :bigint           not null, primary key
#  sakuhinmeiyomi     :text
#  sakuhinmei         :text
#  fukudaiyomi        :text
#  fukudai            :text
#  sakuhinshuumeiyomi :text
#  sakuhinshuumei     :text
#  gendai             :text
#  kana               :text
#  shoshutu           :text
#  memo               :text
#  bikou              :text
#  status             :text
#  statusdate         :text
#  copyright          :boolean
#  seiyomi            :text
#  sei                :text
#  seieiji            :text
#  meiyomi            :text
#  mei                :text
#  meieiji            :text
#  jbikou             :text
#  seimeiyomi         :text
#  seimei             :text
#  email              :text
#  url                :text
#  bookname           :text
#  publisher          :text
#  firstversion       :text
#  versioninput       :text
#  bookname2          :text
#  publisher2         :text
#  firstversion2      :text
#  personid           :text
#  workerid           :text
#  insdate            :date
#  sts                :integer
#  bkbikou            :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :receipt do
    sakuhinmeiyomi { "MyText" }
    sakuhinmei { "MyText" }
    fukudaiyomi { "MyText" }
    fukudai { "MyText" }
    sakuhinshuumeiyomi { "MyText" }
    sakuhinshuumei { "MyText" }
    gendai { "MyText" }
    kana { "MyText" }
    shoshutu { "MyText" }
    memo { "MyText" }
    bikou { "MyText" }
    status { "MyText" }
    statusdate { "MyText" }
    copyright { false }
    seiyomi { "MyText" }
    sei { "MyText" }
    seieiji { "MyText" }
    meiyomi { "MyText" }
    mei { "MyText" }
    meieiji { "MyText" }
    jbikou { "MyText" }
    seimeiyomi { "MyText" }
    seimei { "MyText" }
    email { "MyText" }
    url { "MyText" }
    bookname { "MyText" }
    publisher { "MyText" }
    firstversion { "MyText" }
    versioninput { "MyText" }
    bookname2 { "MyText" }
    publisher2 { "MyText" }
    firstversion2 { "MyText" }
    personid { "MyText" }
    workerid { "MyText" }
    insdate { "2021-04-29" }
    sts { 1 }
    bkbikou { "MyText" }
  end
end
