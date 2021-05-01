# == Schema Information
#
# Table name: compresstypes
#
#  id         :bigint           not null, primary key
#  name       :text
#  extension  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Compresstype < ApplicationRecord
end
