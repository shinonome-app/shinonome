# frozen_string_literal: true
# == Schema Information
#
# Table name: bookfiles
#
#  id               :integer          not null, primary key
#  book_id          :integer          not null
#  filetype_id      :integer          not null
#  compresstype_id  :integer          not null
#  filesize         :integer
#  user_id          :integer
#  url              :text
#  filename         :text             not null
#  opened_on        :date
#  revision_count   :integer
#  file_encoding_id :integer          not null
#  charset_id       :integer          not null
#  note             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_bookfiles_on_book_id           (book_id)
#  index_bookfiles_on_charset_id        (charset_id)
#  index_bookfiles_on_compresstype_id   (compresstype_id)
#  index_bookfiles_on_file_encoding_id  (file_encoding_id)
#  index_bookfiles_on_filetype_id       (filetype_id)
#

FactoryBot.define do
  factory :bookfile do
    book
    filetype
    user
    compresstype
    file_encoding
    charset
    filesize { 1000 }
    url { 'MyText' }
    filename { 'MyText' }
    opened_on { '2021-04-29' }
    revision_count { 1 }
    note { 'MyText' }
  end
end
