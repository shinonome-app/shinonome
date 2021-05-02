# == Schema Information
#
# Table name: book_workers
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  book_id        :bigint
#  worker_id      :bigint
#  worker_role_id :bigint
#
require 'rails_helper'

RSpec.describe BookWorker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
