# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  last_name       :text             not null
#  last_name_kana  :text             not null
#  last_name_en    :text
#  first_name      :text
#  first_name_kana :text
#  first_name_en   :text
#  born_on         :date
#  died_on         :date
#  copyright_flag  :boolean          not null
#  email           :text
#  url             :text
#  description     :text
#  note_user_id    :integer
#  basename        :text
#  note            :text
#  updated_by      :text
#  sortkey         :text
#  sortkey2        :text
#  input_count     :integer
#  publish_count   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe Person, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
