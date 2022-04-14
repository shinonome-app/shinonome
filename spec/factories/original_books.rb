# frozen_string_literal: true

# == Schema Information
#
# Table name: original_books
#
#  id            :bigint           not null, primary key
#  first_pubdate :text
#  input_edition :text
#  note          :text
#  proof_edition :text
#  publisher     :text
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  work_id       :bigint
#  worktype_id   :bigint
#
# Indexes
#
#  index_original_books_on_work_id      (work_id)
#  index_original_books_on_worktype_id  (worktype_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#  fk_rails_...  (worktype_id => worktypes.id)
#

FactoryBot.define do
  factory :original_book do
    work_id { 1 }
    title { 'MyText' }
    publisher { 'MyText' }
    first_pubdate { 'MyText' }
    input_edition { 'MyText' }
    proof_edition { 'MyText' }
    worktype_id { 'MyText' }
    note { 'MyText' }
  end
end
