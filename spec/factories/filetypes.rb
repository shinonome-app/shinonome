# == Schema Information
#
# Table name: filetypes
#
#  id         :bigint           not null, primary key
#  extension  :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :filetype do
    name { "MyText" }
    extension { "MyText" }
  end
end
