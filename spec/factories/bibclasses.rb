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
FactoryBot.define do
  factory :bibclasse do
    book_id { 1 }
    name { "MyText" }
    num { "MyText" }
    note { "MyText" }
  end
end
