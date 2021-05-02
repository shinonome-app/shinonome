# frozen_string_literal: true

# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  name       :text
#  note       :text
#  num        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#
class Bibclass < ApplicationRecord
  belongs_to :book
end
