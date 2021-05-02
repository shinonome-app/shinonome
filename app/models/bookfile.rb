# == Schema Information
#
# Table name: bookfiles
#
#  id               :bigint           not null, primary key
#  book_id          :integer
#  filetype_id      :integer
#  compresstype_id  :integer
#  filesize         :integer
#  user_id          :integer
#  url              :text
#  filename         :text
#  opened_on        :date
#  fixnum           :integer
#  file_encoding_id :integer
#  charset_id       :integer
#  note             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Bookfile < ApplicationRecord
  belongs_to :book
  belongs_to :filetype
  belongs_to :compresstype
  belongs_to :user
  belongs_to :file_encoding
  belongs_to :charset
end
