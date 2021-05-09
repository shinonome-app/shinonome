# frozen_string_literal: true

# == Schema Information
#
# Table name: charsets
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Charset < ApplicationRecord
end
