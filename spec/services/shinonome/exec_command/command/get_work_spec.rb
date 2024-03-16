# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetWork do
  describe '.execute' do
    before do
      create(:work)
      create(:work)
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['book'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetWork.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'book.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,作品名,作品名読み,副題,副題読み,作品集名,作品集名読み,原題,仮名遣い種別,初出,作品について,状態,状態の開始日,著作権フラグ,備考,底本管理情報,最終更新日,更新者,ソート用読み\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          work2 = Work.find(row2[0])

          expect(row2[0]).to eq work2.id.to_s
          expect(row2[1]).to eq work2.title
          expect(row2[2]).to eq work2.title_kana
          expect(row2[3]).to eq work2.subtitle
          expect(row2[4]).to eq work2.subtitle_kana
          expect(row2[5]).to eq work2.collection.to_s
          expect(row2[6]).to eq work2.collection_kana.to_s
          expect(row2[7]).to eq work2.original_title.to_s
          expect(row2[8]).to eq work2.kana_type_name
          expect(row2[9]).to eq work2.first_appearance
          expect(row2[10]).to eq work2.description
          expect(row2[11]).to eq work2.work_status.name
          expect(row2[12]).to eq work2.started_on.to_s
          expect(row2[13]).to eq work2.copyright_char
          expect(row2[14]).to eq work2.note
          expect(row2[15]).to eq work2.work_secret&.orig_text.to_s
          expect(row2[16]).to eq work2.updated_at.to_s
          expect(row2[17]).to eq work2.user.username
          expect(row2[18]).to eq work2.sortkey

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          work3 = Work.find(row3[0])

          expect(row3[0]).to eq work3.id.to_s
          expect(row3[1]).to eq work3.title
          expect(row3[2]).to eq work3.title_kana
          expect(row3[3]).to eq work3.subtitle
          expect(row3[4]).to eq work3.subtitle_kana
          expect(row3[5]).to eq work3.collection.to_s
          expect(row3[6]).to eq work3.collection_kana.to_s
          expect(row3[7]).to eq work3.original_title.to_s
          expect(row3[8]).to eq work3.kana_type_name
          expect(row3[9]).to eq work3.first_appearance
          expect(row3[10]).to eq work3.description
          expect(row3[11]).to eq work3.work_status.name
          expect(row3[12]).to eq work3.started_on.to_s
          expect(row3[13]).to eq work3.copyright_char
          expect(row3[14]).to eq work3.note
          expect(row3[15]).to eq work3.work_secret&.orig_text.to_s
          expect(row3[16]).to eq work3.updated_at.to_s
          expect(row3[17]).to eq work3.user.username
          expect(row3[18]).to eq work3.sortkey
        end
      end
    end
  end
end
