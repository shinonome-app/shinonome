# frozen_string_literal: true

# == Schema Information
#
# Table name: book_workers
#
#  id             :integer          not null, primary key
#  book_id        :integer          not null
#  worker_id      :integer          not null
#  worker_role_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_book_workers_on_book_id         (book_id)
#  index_book_workers_on_worker_id       (worker_id)
#  index_book_workers_on_worker_role_id  (worker_role_id)
#

require 'rails_helper'

RSpec.describe BookWorker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
