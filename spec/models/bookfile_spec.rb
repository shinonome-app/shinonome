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
require 'rails_helper'

RSpec.describe Bookfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
