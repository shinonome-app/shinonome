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
require 'rails_helper'

RSpec.describe Bookfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
