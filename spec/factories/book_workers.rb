# == Schema Information
#
# Table name: book_workers
#
#  id             :bigint           not null, primary key
#  book_id        :integer
#  woker_id       :integer
#  worker_role_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :book_worker do
    book_id { 1 }
    woker_id { 1 }
    worker_role_id { 1 }
  end
end
