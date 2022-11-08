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

# 底本
class OriginalBook < ApplicationRecord
  belongs_to :work
  belongs_to :worktype

  validates :title, presence: true

  def self.csv_header
    "bookid,書籍名,出版社名,初版発行年,入力に使用した版,校正に使用した版,種別フラグ,備考\r\n"
  end

  def to_csv
    array = [work_id, title, publisher, first_pubdate, input_edition, proof_edition, worktype.name, note]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
