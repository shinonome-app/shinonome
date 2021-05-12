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
class Bookfile < ApplicationRecord
  belongs_to :book
  belongs_to :filetype
  belongs_to :compresstype
  belongs_to :user
  belongs_to :file_encoding
  belongs_to :charset

  has_one_attached :bookdata

  validates :filename, :book, :charset, :compresstype, :file_encoding, :filetype, presence: true
end
