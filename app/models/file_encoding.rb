# == Schema Information
#
# Table name: file_encodings
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class FileEncoding < ApplicationRecord
end
