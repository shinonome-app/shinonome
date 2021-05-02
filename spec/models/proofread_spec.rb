# == Schema Information
#
# Table name: proofreads
#
#  id          :bigint           not null, primary key
#  book_id     :integer
#  book_copy   :text
#  book_print  :text
#  refbook     :text
#  bookfile_id :integer
#  address     :text
#  memo        :text
#  worker_id   :integer
#  worker_kana  :text
#  worker_name :text
#  email       :text
#  url         :text
#  person_id   :integer
#  sts1        :text
#  sts2        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Proofread, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
