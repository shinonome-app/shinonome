# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id         :integer          not null, primary key
#  command    :text
#  user_id    :integer
#  separator  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
