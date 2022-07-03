# frozen_string_literal: true

# == Schema Information
#
# Table name: compresstypes
#
#  id         :bigint           not null, primary key
#  extension  :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Compresstype < ApplicationRecord # rubocop:disable Style/Documentation
  def compressed?
    id != 1
  end

  def none?
    id == 1
  end

  def zip?
    id == 2
  end

  def gzip?
    id == 3
  end

  def lha?
    id == 4
  end

  def sit?
    id == 5
  end
end
