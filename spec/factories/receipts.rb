# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                 :bigint           not null, primary key
#  bikou              :text
#  bkbikou            :text
#  bookname           :text
#  bookname2          :text
#  copyright          :boolean
#  email              :text
#  firstversion       :text
#  firstversion2      :text
#  fukudai            :text
#  fukudaiyomi        :text
#  gendai             :text
#  insdate            :date
#  jbikou             :text
#  kana               :text
#  mei                :text
#  meieiji            :text
#  meiyomi            :text
#  memo               :text
#  personid           :text
#  publisher          :text
#  publisher2         :text
#  sakuhinmei         :text
#  sakuhinmeiyomi     :text
#  sakuhinshuumei     :text
#  sakuhinshuumeiyomi :text
#  sei                :text
#  seieiji            :text
#  seimei             :text
#  seimeiyomi         :text
#  seiyomi            :text
#  shoshutu           :text
#  status             :text
#  statusdate         :text
#  sts                :integer
#  url                :text
#  versioninput       :text
#  workerid           :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :receipt do
    sakuhinmeiyomi { 'MyText' }
    sakuhinmei { 'MyText' }
    fukudaiyomi { 'MyText' }
    fukudai { 'MyText' }
    sakuhinshuumeiyomi { 'MyText' }
    sakuhinshuumei { 'MyText' }
    gendai { 'MyText' }
    kana { 'MyText' }
    shoshutu { 'MyText' }
    memo { 'MyText' }
    bikou { 'MyText' }
    status { 'MyText' }
    statusdate { 'MyText' }
    copyright { false }
    seiyomi { 'MyText' }
    sei { 'MyText' }
    seieiji { 'MyText' }
    meiyomi { 'MyText' }
    mei { 'MyText' }
    meieiji { 'MyText' }
    jbikou { 'MyText' }
    seimeiyomi { 'MyText' }
    seimei { 'MyText' }
    email { 'MyText' }
    url { 'MyText' }
    bookname { 'MyText' }
    publisher { 'MyText' }
    firstversion { 'MyText' }
    versioninput { 'MyText' }
    bookname2 { 'MyText' }
    publisher2 { 'MyText' }
    firstversion2 { 'MyText' }
    personid { 'MyText' }
    workerid { 'MyText' }
    insdate { '2021-04-29' }
    sts { 1 }
    bkbikou { 'MyText' }
  end
end
