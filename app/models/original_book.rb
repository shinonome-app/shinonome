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
#  booktype_id   :bigint
#
# Indexes
#
#  index_original_books_on_work_id      (work_id)
#  index_original_books_on_booktype_id  (booktype_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#  fk_rails_...  (booktype_id => booktypes.id)
#

# 底本
class OriginalBook < ApplicationRecord
  belongs_to :work
  belongs_to :booktype

  validates :booktype_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :title, presence: true

  def self.csv_header
    "bookid,書籍名,出版社名,初版発行年,入力に使用した版,校正に使用した版,種別フラグ,備考\r\n"
  end

  def to_csv
    array = [work_id, title, publisher, first_pubdate, input_edition, proof_edition, booktype.name, note]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
