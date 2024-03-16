# frozen_string_literal: true

# == Schema Information
#
# Table name: original_books
#
#  id            :bigint           not null, primary key
#  first_pubdate :text
#  input_edition :text
#  proof_edition :text
#  publisher     :text
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  booktype_id   :bigint
#  work_id       :bigint
#
# Indexes
#
#  index_original_books_on_booktype_id  (booktype_id)
#  index_original_books_on_work_id      (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (booktype_id => booktypes.id)
#  fk_rails_...  (work_id => works.id)
#

FactoryBot.define do
  factory :original_book do
    work
    title { "底本タイトル#{work.id}" }
    publisher { "底本出版社#{work.id}" }
    first_pubdate { "初出年月日#{work.id}" }
    input_edition { "入力使用版#{work.id}" }
    proof_edition { "校正使用版#{work.id}" }
    booktype_id { 1 }

    after(:build) do |original_book|
      create(:original_book_secret, original_book:)
    end
  end
end
