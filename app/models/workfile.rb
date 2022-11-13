# frozen_string_literal: true

# == Schema Information
#
# Table name: workfiles
#
#  id               :bigint           not null, primary key
#  filename         :text
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

  has_one_attached :workdata if defined?(ActiveStorage)

  after_save :set_filename
  validates :filetype_id, numericality: { only_integer: true }
  validates :charset_id, numericality: { only_integer: true }
  validates :compresstype_id, numericality: { only_integer: true }
  validates :file_encoding_id, numericality: { only_integer: true }

  def html?
    filetype&.html?
  end

  def text?
    filetype&.text?
  end

  def zip?
    compresstype&.zip?
  end

  def using_ruby?
    content = uncompressed_workdata
    return false if content.nil?

    content.force_encoding('Shift_JIS')
    utf8_content = content.encode('UTF-8')
    utf8_content.match?(/《.*》/)
  end

  def compressed?
    compresstype&.compressed?
  end

  def uncompressed_workdata
    return nil if workdata.blank? || compresstype.blank?

    content = workdata.open { |file| file&.read }
    return content unless compressed?

    raise 'サポートしていない圧縮形式です' if compresstype.lha? || compresstype.sit?

    if compresstype.zip?
      unzip_workdata
    elsif compresstype.gzip?
      gunzip_workdata
    else
      raise 'サポートしていない圧縮形式です'
    end
  end

  def unzip_workdata
    workdata.open do |file|
      Zip::File.open(file) do |zip|
        zip.each do |entry|
          return entry.get_input_stream.read if entry.name =~ /\.txt\z/
        end
      end
    end
  end

  def gunzip_workdata
    workdata.open do |file|
      Zlib::GzipReader.open(file) do |gz|
        return gz.read
      end
    end
  end

  def generate_filename
    # URLがある場合はfilenameは空、filesizeは0
    return if url.present?

    ext = if compresstype&.compressed?
            compresstype.extension
          elsif filetype&.rtxt?
            'txt'
          else
            filetype&.extension
          end

    if filetype&.rtxt?
      "#{work.id}_ruby_#{id}.#{ext}"
    elsif compresstype&.compressed?
      "#{work.id}_#{filetype&.extension}_#{id}.#{ext}"
    else
      "#{work.id}_#{id}.#{ext}"
    end
  end

  private

  def set_filename
    update_columns(filename: generate_filename) if filename.blank? # rubocop:disable Rails/SkipsModelValidations
  end
end
