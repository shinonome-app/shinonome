# frozen_string_literal: true

# == Schema Information
#
# Table name: workfiles
#
#  id               :bigint           not null, primary key
#  filename         :text             not null
#  filesize         :integer
#  note             :text
#  opened_on        :date
#  revision_count   :integer
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  charset_id       :bigint           not null
#  compresstype_id  :bigint           not null
#  file_encoding_id :bigint           not null
#  filetype_id      :bigint           not null
#  user_id          :bigint
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

# 作品ファイル
class Workfile < ApplicationRecord
  belongs_to :work
  belongs_to :filetype
  belongs_to :compresstype
  belongs_to :user, class_name: 'Shinonome::User', optional: true
  belongs_to :file_encoding
  belongs_to :charset

  has_one_attached :workdata

  validates :filename, presence: true

  def html?
    filetype&.html?
  end

  def filename
    ext = if compresstype.compressed?
            compresstype.extension
          else
            filetype&.extension
          end
    "#{work.id}_ruby_#{id}.#{ext}"
  end
end
