# frozen_string_literal: true

# == Schema Information
#
# Table name: original_works
#
#  id            :integer          not null, primary key
#  work_id       :integer
#  title         :text             not null
#  publisher     :text
#  first_pubdate :text
#  input_edition :text
#  proof_edition :text
#  worktype_id   :integer
#  note          :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_original_works_on_work_id      (work_id)
#  index_original_works_on_worktype_id  (worktype_id)
#

FactoryBot.define do
  factory :original_work do
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
