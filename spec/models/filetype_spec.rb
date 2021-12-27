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

require 'rails_helper'

RSpec.describe Filetype, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
