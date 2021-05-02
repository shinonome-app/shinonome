# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  book_id    :integer
#  name       :text
#  num        :text
#  note       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bibclasse < ApplicationRecord
  belongs_to :book
end
