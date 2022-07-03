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

require 'rails_helper'

RSpec.describe Workfile, type: :model do
  describe '#using_ruby?' do
    let(:workfile) { create(:workfile, :html) }

    it 'ルビがあればtrue' do
      workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/text/01jo.txt', 'text/plain'))
      expect(workfile.using_ruby?).to be true
    end

    it 'ルビがなければfalse' do
      workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/text/fukei.txt', 'text/plain'))
      expect(workfile.using_ruby?).to be false
    end

    it 'ファイルがなければfalse' do
      expect(workfile.using_ruby?).to be false
    end
  end

  describe '#generate_filename' do
    context 'htmlの場合' do
      it '正しいファイル名を返す' do
        workfile = create(:workfile, :html) do |tmp_workfile|
          tmp_workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/html/01jo.html', 'text/html'))
        end
        expect(workfile.generate_filename).to eq "#{workfile.work_id}_#{workfile.id}.html"
      end
    end

    context 'zipの場合' do
      it 'ルビがある場合は_ruby_つきのファイル名を返す' do
        workfile = create(:workfile, :zip) do |tmp_workfile|
          tmp_workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/zip/01jo.zip', 'application/zip'))
          tmp_workfile.filetype_id = 1
        end
        expect(workfile.generate_filename).to eq "#{workfile.work_id}_ruby_#{workfile.id}.zip"
      end

      it 'ルビがない場合は_txt_つきのファイル名を返す' do
        workfile = create(:workfile, :zip) do |tmp_workfile|
          tmp_workfile.workdata.attach(Rack::Test::UploadedFile.new('spec/fixtures/zip/fukei.zip', 'application/zip'))
          tmp_workfile.filetype_id = 2
        end
        expect(workfile.generate_filename).to eq "#{workfile.work_id}_txt_#{workfile.id}.zip"
      end
    end
  end
end
