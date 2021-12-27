# frozen_string_literal: true
# == Schema Information
#
# Table name: proofreads
#
#  id            :integer          not null, primary key
#  book_id       :integer          not null
#  book_copy     :text
#  book_print    :text
#  proof_edition :text
#  bookfile      :integer
#  address       :text
#  memo          :text
#  worker_id     :integer
#  worker_kana   :text
#  worker_name   :text
#  email         :text
#  url           :text
#  person_id     :integer          not null
#  assign_status :text
#  order_status  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_proofreads_on_book_id    (book_id)
#  index_proofreads_on_person_id  (person_id)
#

class Proofread < ApplicationRecord
  belongs_to :book
  belongs_to :bookfile
  belongs_to :worker
end
