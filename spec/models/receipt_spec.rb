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
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
