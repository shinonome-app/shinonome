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
