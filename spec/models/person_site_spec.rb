# frozen_string_literal: true

# == Schema Information
#
# Table name: person_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#  site_id    :bigint           not null
#
require 'rails_helper'

RSpec.describe PersonSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
