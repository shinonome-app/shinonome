# frozen_string_literal: true

# == Schema Information
#
# Table name: filetypes
#
#  id         :integer          not null, primary key
#  name       :text
#  extension  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :filetype do
    name { 'MyText' }
    extension { 'MyText' }
  end
end
