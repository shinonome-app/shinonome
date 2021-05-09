# frozen_string_literal: true

# == Schema Information
#
# Table name: book_statuses
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  sort_order :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BookStatus < ApplicationRecord
  has_many :books, dependent: :restrict_with_error
end
