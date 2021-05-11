# frozen_string_literal: true

# == Schema Information
#
# Table name: proofreads
#
#  id            :bigint           not null, primary key
#  address       :text
#  assign_status :text
#  book_copy     :text
#  book_print    :text
#  bookfile      :bigint
#  email         :text
#  memo          :text
#  order_status  :text
#  proof_edition :text
#  url           :text
#  worker_kana   :text
#  worker_name   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  book_id       :bigint           not null
#  person_id     :bigint           not null
#  worker_id     :bigint
#
# Indexes
#
#  index_proofreads_on_book_id    (book_id)
#  index_proofreads_on_person_id  (person_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (person_id => people.id)
#
require 'rails_helper'

RSpec.describe Proofread, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
