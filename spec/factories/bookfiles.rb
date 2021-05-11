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
#  charset_id       :bigint           not null
#  compresstype_id  :bigint           not null
#  file_encoding_id :bigint           not null
#  filetype_id      :bigint           not null
#  user_id          :bigint
#
# Indexes
#
#  index_bookfiles_on_book_id           (book_id)
#  index_bookfiles_on_charset_id        (charset_id)
#  index_bookfiles_on_compresstype_id   (compresstype_id)
#  index_bookfiles_on_file_encoding_id  (file_encoding_id)
#  index_bookfiles_on_filetype_id       (filetype_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (charset_id => charsets.id)
#  fk_rails_...  (compresstype_id => compresstypes.id)
#  fk_rails_...  (file_encoding_id => file_encodings.id)
#  fk_rails_...  (filetype_id => filetypes.id)
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
