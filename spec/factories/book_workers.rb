# frozen_string_literal: true

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
FactoryBot.define do
  factory :book_worker do
    book_id { 1 }
    worker_id { 1 }
    worker_role_id { 1 }
  end
end
