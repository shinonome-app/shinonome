# frozen_string_literal: true

# == Schema Information
#
# Table name: workfiles
#
#  id               :bigint           not null, primary key
#  filename         :text
#  filesize         :integer
#  last_updated_on  :date
#  registered_on    :date
#  revision_count   :integer
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  charset_id       :bigint           not null
#  compresstype_id  :bigint           not null
#  file_encoding_id :bigint           not null
#  filetype_id      :bigint           not null
#  work_id          :bigint           not null
#
# Indexes
#
#  index_workfiles_on_charset_id        (charset_id)
#  index_workfiles_on_compresstype_id   (compresstype_id)
#  index_workfiles_on_file_encoding_id  (file_encoding_id)
#  index_workfiles_on_filetype_id       (filetype_id)
#  index_workfiles_on_work_id           (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (charset_id => charsets.id)
#  fk_rails_...  (compresstype_id => compresstypes.id)
#  fk_rails_...  (file_encoding_id => file_encodings.id)
#  fk_rails_...  (filetype_id => filetypes.id)
#  fk_rails_...  (work_id => works.id)
#

FactoryBot.define do
  factory :workfile do
    transient do
      n { rand(1000) }
    end

    work
    filesize { 1000 }
    filename { nil }
    revision_count { 1 }

    filetype { Filetype.find(1) }
    compresstype { Compresstype.find(1) }
    charset_id { 1 }
    file_encoding_id { 1 }

    after(:build) do |workfile|
      create(:workfile_secret, workfile:)
    end

    trait :zip do
      compresstype { Compresstype.find(2) }
      filetype { Filetype.find(1) }
    end

    trait :xhtml do
      compresstype { Compresstype.find(1) }
      filetype { Filetype.find(9) }
    end
  end
end
