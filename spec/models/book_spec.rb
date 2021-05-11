# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                    :bigint           not null, primary key
#  author_display_name   :text
#  collection            :text
#  collection_kana       :text
#  copyright_flag        :boolean          not null
#  description           :text
#  first_appearance      :text
#  note                  :text
#  orig_text             :text
#  original_title        :text
#  sortkey               :text
#  started_on            :date             not null
#  subtitle              :text
#  subtitle_kana         :text
#  title                 :text             not null
#  title_kana            :text
#  update_flag           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  book_status_id        :bigint           not null
#  description_person_id :bigint
#  kana_type_id          :bigint           not null
#  user_id               :bigint           not null
#
# Indexes
#
#  index_books_on_book_status_id  (book_status_id)
#  index_books_on_kana_type_id    (kana_type_id)
#  index_books_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_status_id => book_statuses.id)
#  fk_rails_...  (kana_type_id => kana_types.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
