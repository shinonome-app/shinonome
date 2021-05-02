# frozen_string_literal: true

# == Schema Information
#
# Table name: proofreads
#
#  id          :bigint           not null, primary key
#  address     :text
#  book_copy   :text
#  book_print  :text
#  email       :text
#  memo        :text
#  refbook     :text
#  sts1        :text
#  sts2        :text
#  url         :text
#  worker_kana :text
#  worker_name :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  book_id     :bigint
#  bookfile_id :bigint
#  person_id   :bigint
#  worker_id   :bigint
#
require 'rails_helper'

RSpec.describe Proofread, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
