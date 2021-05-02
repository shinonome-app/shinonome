# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  basename        :text
#  born_on         :date
#  copyright_flag  :boolean
#  description     :text
#  died_on         :date
#  email           :text
#  first_name      :text
#  first_name_en   :text
#  first_name_kana :text
#  input_count     :integer
#  last_name       :text
#  last_name_en    :text
#  last_name_kana  :text
#  note            :text
#  publish_count   :integer
#  sortkey         :text
#  sortkey2        :text
#  updated_by      :text
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  note_user_id    :bigint
#
require 'rails_helper'

RSpec.describe Person, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
