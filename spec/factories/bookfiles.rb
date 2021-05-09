# frozen_string_literal: true

# == Schema Information
#
# Table name: bookfiles
#
#  id               :bigint           not null, primary key
#  filename         :text             not null
#  filesize         :integer
#  note             :text
#  opened_on        :date
#  revision_count   :integer
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  book_id          :bigint           not null
#  charset_id       :bigint
#  compresstype_id  :bigint
#  file_encoding_id :bigint
#  filetype_id      :bigint
#  user_id          :bigint
#
FactoryBot.define do
  factory :bookfile do
    book_id { 1 }
    filetype_id { 1 }
    compresstype_id { 1 }
    filesize { 1 }
    user_id { 1 }
    url { 'MyText' }
    filename { 'MyText' }
    opened_on { '2021-04-29' }
    revision_count { 1 }
    file_encoding_id { '' }
    charset_id { 1 }
    note { 'MyText' }
  end
end
