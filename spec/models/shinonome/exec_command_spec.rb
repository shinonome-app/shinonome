# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id          :bigint           not null, primary key
#  command     :text
#  executed_at :datetime
#  result      :jsonb
#  separator   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
