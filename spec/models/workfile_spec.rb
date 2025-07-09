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

require 'rails_helper'

RSpec.describe Workfile do
  describe '.parse' do
    context 'zipの場合' do
      let!(:work) { create(:work, :with_person, :with_zip_workfile) }

      it 'person_idが違っていればエラー' do
        url = 'https://www.aozora.gr.jp/cards/999999/files/46340_ruby_24939.zip'
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'workfile_idが違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/123_ruby_99999.zip"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'work_idが違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/123_ruby_#{work.workfile.id}.zip"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '拡張子が違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/#{work.id}_ruby_#{work.workfile.id}.html"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '拡張名が違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/#{work.id}_#{work.workfile.id}.zip"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '全部正しければエラーがない' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/#{work.id}_ruby_#{work.workfile.id}.zip"
        expect { Workfile.parse(url) }.not_to raise_error
      end
    end

    context 'xhtmlの場合' do
      let!(:work) { create(:work, :with_person, :with_xhtml_workfile) }

      it 'person_idが違っていればエラー' do
        url = 'https://www.aozora.gr.jp/cards/999999/files/46340_24939.html'
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'workfile_idが違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/123_99999.html"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'work_idが違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/123_#{work.workfile.id}.html"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '拡張子が違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/#{work.id}_#{work.workfile.id}.xhtml"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '拡張名が違っていればエラー' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/#{work.id}_ruby_#{work.workfile.id}.html"
        expect { Workfile.parse(url) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '全部正しければエラーがない' do
        url = "https://www.aozora.gr.jp/cards/#{work.card_person_id}/files/#{work.id}_#{work.workfile.id}.html"
        expect { Workfile.parse(url) }.not_to raise_error
      end
    end
  end

  describe '#using_ruby?' do
    let(:workfile) { create(:workfile, :xhtml) }

    after do
      workfile.filesystem.delete if workfile.filesystem.exists?
    end

    it 'ルビがあればtrue' do
      workfile.filesystem.copy_from('spec/fixtures/text/01jo.txt')
      expect(workfile.using_ruby?).to be true
    end

    it 'ルビがなければfalse' do
      workfile.filesystem.copy_from('spec/fixtures/text/fukei.txt')
      expect(workfile.using_ruby?).to be false
    end

    it 'ファイルがなければfalse' do
      expect(workfile.using_ruby?).to be false
    end
  end

  describe '#generate_filename' do
    context 'xhtmlの場合' do
      it '正しいファイル名を返す' do
        workfile = create(:workfile, :xhtml) do |tmp_workfile|
          tmp_workfile.filesystem.copy_from('spec/fixtures/html/01jo.html')
        end
        expect(workfile.generate_filename).to eq "#{workfile.work_id}_#{workfile.id}.html"
        workfile.filesystem.delete if workfile.filesystem.exists?
      end
    end

    context 'zipの場合' do
      it 'ルビがある場合は_ruby_つきのファイル名を返す' do
        workfile = create(:workfile, :zip) do |tmp_workfile|
          tmp_workfile.filesystem.copy_from('spec/fixtures/zip/01jo.zip')
          tmp_workfile.filetype_id = 1
        end
        expect(workfile.generate_filename).to eq "#{workfile.work_id}_ruby_#{workfile.id}.zip"
        workfile.filesystem.delete if workfile.filesystem.exists?
      end

      it 'ルビがない場合は_txt_つきのファイル名を返す' do
        workfile = create(:workfile, :zip) do |tmp_workfile|
          tmp_workfile.filesystem.copy_from('spec/fixtures/zip/fukei.zip')
          tmp_workfile.filetype_id = 2
        end
        expect(workfile.generate_filename).to eq "#{workfile.work_id}_txt_#{workfile.id}.zip"
        workfile.filesystem.delete if workfile.filesystem.exists?
      end
    end
  end

  describe '#download_url' do
    let(:work) { create(:work, :with_person) }

    context 'xhtmlの場合' do
      let(:workfile) { create(:workfile, :xhtml, work:) }

      it '正しいurlを返す' do
        allow(Rails.application.config.x).to receive(:main_site_url).and_return('https://example.com')
        expect(workfile.download_url).to eq("https://example.com/cards/#{work.card_person_id}/files/#{work.id}_#{workfile.id}.html")
      end
    end

    context 'zipの場合' do
      let(:workfile) { create(:workfile, :zip, work:) }

      it '正しいurlを返す' do
        allow(Rails.application.config.x).to receive(:main_site_url).and_return('https://example.com')
        expect(workfile.download_url).to eq("https://example.com/cards/#{work.card_person_id}/files/#{work.id}_ruby_#{workfile.id}.zip")
      end
    end
  end

  describe '#calc_ext' do
    let(:work) { create(:work, :with_person) }

    context 'txt + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 2) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('txt')
      end
    end

    context 'rtxt + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 1) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('txt')
      end
    end

    context 'html + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 3) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('html')
      end
    end

    context 'pdf + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 7) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('pdf')
      end
    end

    context 'txt + zipの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 2, filetype_id: 2) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('zip')
      end
    end

    context 'txt + gzipの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 3, filetype_id: 2) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('gz')
      end
    end

    context 'txt + lhaの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 4, filetype_id: 2) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('lzh')
      end
    end

    context 'pdf + gzipの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 3, filetype_id: 7) }

      it '正しい拡張子を返す' do
        expect(workfile.calc_ext).to eq('gz')
      end
    end
  end

  describe '#calc_extension' do
    let(:work) { create(:work, :with_person) }

    context 'txt + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 2) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq(nil)
      end
    end

    context 'rtxt + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 1) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq('ruby')
      end
    end

    context 'html + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 3) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq(nil)
      end
    end

    context 'pdf + 圧縮なしの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 1, filetype_id: 7) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq(nil)
      end
    end

    context 'txt + zipの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 2, filetype_id: 2) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq('txt')
      end
    end

    context 'txt + gzipの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 3, filetype_id: 2) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq('txt')
      end
    end

    context 'txt + lhaの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 4, filetype_id: 2) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq('txt')
      end
    end

    context 'pdf + gzipの場合' do
      let(:workfile) { create(:workfile, work:, compresstype_id: 3, filetype_id: 7) }

      it '正しい拡張名を返す' do
        expect(workfile.calc_extension).to eq('pdf')
      end
    end
  end

  describe 'validations' do
    let(:work) { create(:work) }

    describe 'filename validation' do
      it '正常なファイル名を受け入れる' do
        workfile = build(:workfile, work: work, filename: 'normal_file.txt')
        expect(workfile).to be_valid
      end

      it '英数字とハイフン、アンダースコア、ドットを含むファイル名を受け入れる' do
        workfile = build(:workfile, work: work, filename: 'test-file_123.txt')
        expect(workfile).to be_valid
      end

      it '空のファイル名を受け入れる' do
        workfile = build(:workfile, work: work, filename: '')
        expect(workfile).to be_valid
      end

      it 'nilのファイル名を受け入れる' do
        workfile = build(:workfile, work: work, filename: nil)
        expect(workfile).to be_valid
      end

      it '許可されていない文字を含むファイル名を拒否する' do
        ['<script>', 'file>test', 'file&test', 'file"test', "file'test", 'file|test', 'file:test',
         '日本語.txt', 'file name.txt', 'file(1).txt', 'file[1].txt'].each do |invalid_filename|
          workfile = Workfile.new(
            work: work,
            filename: invalid_filename,
            filetype_id: 1,
            compresstype_id: 1,
            file_encoding_id: 1,
            charset_id: 1
          )
          expect(workfile).not_to be_valid
          expect(workfile.errors[:filename]).to include('に使用できない文字が含まれています')
        end
      end
    end
  end
end
