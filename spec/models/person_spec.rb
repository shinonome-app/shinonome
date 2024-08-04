# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  basename        :text
#  born_on         :text
#  copyright_flag  :boolean          default(FALSE), not null
#  description     :text
#  died_on         :text
#  first_name      :text
#  first_name_en   :text
#  first_name_kana :text
#  input_count     :integer
#  last_name       :text             not null
#  last_name_en    :text
#  last_name_kana  :text             not null
#  publish_count   :integer
#  sortkey         :text
#  sortkey2        :text
#  updated_by      :bigint
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Person do
  pending "add some examples to (or delete) #{__FILE__}"
end
