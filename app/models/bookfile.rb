# frozen_string_literal: true

# == Schema Information
#
# Table name: bookfiles
#
#  id               :bigint           not null, primary key
#  filename         :text
#  filesize         :integer
#  fixnum           :integer
#  note             :text
#  opened_on        :date
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  book_id          :bigint
#  charset_id       :bigint
#  compresstype_id  :bigint
#  file_encoding_id :bigint
#  filetype_id      :bigint
#  user_id          :bigint
#
class Bookfile < ApplicationRecord
  belongs_to :book
  belongs_to :filetype
  belongs_to :compresstype
  belongs_to :user
  belongs_to :file_encoding
  belongs_to :charset
end
