# frozen_string_literal: true

# == Schema Information
#
# Table name: workfiles
#
#  id               :bigint           not null, primary key
#  filename         :text
#  filesize         :integer
#  last_updated_on  :date
#  registrated_on   :date
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

# 作品ファイル
class Workfile < ApplicationRecord
  belongs_to :work
  belongs_to :filetype
  belongs_to :compresstype
  belongs_to :user, class_name: 'Shinonome::User', optional: true
  belongs_to :file_encoding
  belongs_to :charset

  has_one_attached :workdata if defined?(ActiveStorage)

  has_one :workfile_secret,
          class_name: 'Shinonome::WorkfileSecret',
          required: true,
          dependent: :destroy

  accepts_nested_attributes_for :workfile_secret, update_only: true

  after_save :set_filename

  validates :filetype_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :filetype_id, numericality: { only_integer: true }, if: -> { filetype_id.present? }
  validates :charset_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :charset_id, numericality: { only_integer: true }, if: -> { charset_id.present? }
  validates :compresstype_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :compresstype_id, numericality: { only_integer: true }, if: -> { compresstype_id.present? }
  validates :file_encoding_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :file_encoding_id, numericality: { only_integer: true }, if: -> { file_encoding_id.present? }

  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  def self.parse(url, validate: true)
    # ex.
    #   https://www.aozora.gr.jp/cards/001234/files/46340_24939.html
    #   https://www.aozora.gr.jp/cards/001234/files/46340_ruby_24806.zip
    #
    path = URI.parse(url).path
    case path
    #                person_id         extension          ext
    #                            work_id           workfile_id
    when %r{\A/cards/(\d+)/files/(\d+)_([0-9a-z]+)_(\d+)\.([a-z]+)\z}
      person_id = ::Regexp.last_match(1).to_i
      work_id = ::Regexp.last_match(2).to_i
      extension = ::Regexp.last_match(3)
      workfile_id = ::Regexp.last_match(4).to_i
      ext = ::Regexp.last_match(5)

      workfile = Workfile.find(workfile_id)
      return workfile unless validate

      raise ActiveRecord::RecordNotFound, "work_id should be `#{workfile.work.id}`, but is `#{work_id}`" if workfile.work.id != work_id
      raise ActiveRecord::RecordNotFound, "person_id should be `#{workfile.work.card_person_id}`, but is `#{person_id}`" if workfile.work.card_person_id.to_i != person_id
      raise ActiveRecord::RecordNotFound, "ext should be `#{workfile.calc_ext}`, but is `#{ext}`" if workfile.calc_ext != ext
      raise ActiveRecord::RecordNotFound, "extension should be `#{workfile.calc_extension}`, but is `#{extension}`" if workfile.calc_extension != extension
    #                person_id         extension
    #                            work_id      ext
    when %r{\A/cards/(\d+)/files/(\d+)_(\d+)\.([a-z]+)\z}
      person_id = ::Regexp.last_match(1).to_i
      work_id = ::Regexp.last_match(2).to_i
      workfile_id = ::Regexp.last_match(3).to_i
      ext = ::Regexp.last_match(4)
      extension = nil
      workfile = Workfile.find(workfile_id)
      return workfile unless validate

      raise ActiveRecord::RecordNotFound, "work_id should be `#{workfile.work.id}`, but is `#{work_id}`" if workfile.work.id != work_id
      raise ActiveRecord::RecordNotFound, "person_id should be `#{workfile.work.card_person_id}`, but is `#{person_id}`" if workfile.work.card_person_id.to_i != person_id
      raise ActiveRecord::RecordNotFound, "ext should be `#{workfile.calc_ext}`, but is `#{ext}`" if workfile.calc_ext != ext
      raise ActiveRecord::RecordNotFound, "extension should be `#{workfile.calc_extension}`, but is `#{extension}`" if workfile.calc_extension != extension
    else
      raise ArgumentError, "invalid format: `#{path}`"
    end

    workfile
  end

  def html?
    filetype&.html?
  end

  def text?
    filetype&.text?
  end

  def zip?
    compresstype&.zip?
  end

  def filename_to_download
    if filename.present?
      filename
    else
      "#{work.id}.#{filetype&.extension}"
    end
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

    ext = calc_ext
    extension = calc_extension

    if extension
      "#{work.id}_#{extension}_#{id}.#{ext}"
    else
      "#{work.id}_#{id}.#{ext}"
    end
  end

  def calc_extension
    if filetype&.rtxt?
      'ruby'
    elsif compresstype&.compressed?
      filetype&.extension
    end
  end

  def calc_ext
    if compresstype&.compressed?
      compresstype.extension
    elsif filetype&.rtxt?
      'txt'
    else
      filetype&.extension
    end
  end

  def download_url
    url.presence || (Rails.application.config.x.main_site_url + download_path)
  end

  def download_path
    "/cards/#{work.card_person_id}/files/#{filename}"
  end

  private

  def set_filename
    update_columns(filename: generate_filename) if filename.blank? # rubocop:disable Rails/SkipsModelValidations
  end
end
