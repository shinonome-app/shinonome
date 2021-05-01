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
class Receipt < ApplicationRecord
end
