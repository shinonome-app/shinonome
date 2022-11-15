# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetWorkSite do
  describe '.execute' do
    before do
      create(:work_site) do |work_site1|
        create(:work_person, work: work_site1.work)
      end
      create(:work_site) do |work_site2|
        create(:work_person, work: work_site2.work)
        create(:work_person, work: work_site2.work, role_id: 2)
      end
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['book_site'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetWorkSite.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'book_site.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,作品名,作品名読み,副題,副題読み,作品集名,作品集名読み,原題,仮名遣い種別,初出,状態,状態の開始日,著作権フラグ,備考,底本管理情報,最終更新日,更新者,人物1 ID,人物1 姓名,人物1 役割,人物2 ID,人物2 姓名,人物2 役割,人物3 ID,人物3 姓名,人物2 役割,人物4 ID,人物4 姓名,人物4 役割,関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          work2 = Work.find(row2[0])
          site2 = work2.sites[0]
          work_person2 = work2.work_people[0]

          expect(row2[1]).to eq work2.title
          expect(row2[2]).to eq work2.title_kana
          expect(row2[3]).to eq work2.subtitle
          expect(row2[4]).to eq work2.subtitle_kana
          expect(row2[5]).to eq work2.collection.to_s
          expect(row2[6]).to eq work2.collection_kana.to_s
          expect(row2[7]).to eq work2.original_title.to_s
          expect(row2[8]).to eq work2.kana_type_name
          expect(row2[9]).to eq work2.first_appearance
          expect(row2[10]).to eq work2.work_status.name
          expect(row2[11]).to eq work2.started_on.to_s
          expect(row2[12]).to eq work2.copyright_char
          expect(row2[13]).to eq work2.note
          expect(row2[14]).to eq work2.orig_text.to_s
          expect(row2[15]).to eq work2.updated_at.to_s
          expect(row2[16]).to eq work2.user.username
          expect(row2[17]).to eq work_person2.person.id.to_s
          expect(row2[18]).to eq work_person2.person.name
          expect(row2[19]).to eq work_person2.role.name
          expect(row2[20]).to eq ''
          expect(row2[21]).to eq ''
          expect(row2[22]).to eq ''
          expect(row2[23]).to eq ''
          expect(row2[24]).to eq ''
          expect(row2[25]).to eq ''
          expect(row2[26]).to eq ''
          expect(row2[27]).to eq ''
          expect(row2[28]).to eq ''
          expect(row2[29]).to eq site2.id.to_s
          expect(row2[30]).to eq site2.name
          expect(row2[31]).to eq site2.url
          expect(row2[32]).to eq site2.owner_name
          expect(row2[33]).to eq site2.email
          expect(row2[34]).to eq site2.note

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          work3 = Work.find(row3[0])
          site3 = work3.sites[0]
          work_person3 = work3.work_people[0]
          work_person4 = work3.work_people[1]

          expect(row3[1]).to eq work3.title
          expect(row3[2]).to eq work3.title_kana
          expect(row3[3]).to eq work3.subtitle
          expect(row3[4]).to eq work3.subtitle_kana
          expect(row3[5]).to eq work3.collection.to_s
          expect(row3[6]).to eq work3.collection_kana.to_s
          expect(row3[7]).to eq work3.original_title.to_s
          expect(row3[8]).to eq work3.kana_type_name
          expect(row3[9]).to eq work3.first_appearance
          expect(row3[10]).to eq work3.work_status.name
          expect(row3[11]).to eq work3.started_on.to_s
          expect(row3[12]).to eq work3.copyright_char
          expect(row3[13]).to eq work3.note
          expect(row3[14]).to eq work3.orig_text.to_s
          expect(row3[15]).to eq work3.updated_at.to_s
          expect(row3[16]).to eq work3.user.username
          expect(row3[17]).to eq work_person3.person.id.to_s
          expect(row3[18]).to eq work_person3.person.name
          expect(row3[19]).to eq work_person3.role.name
          expect(row3[20]).to eq work_person4.person.id.to_s
          expect(row3[21]).to eq work_person4.person.name
          expect(row3[22]).to eq work_person4.role.name
          expect(row3[23]).to eq ''
          expect(row3[24]).to eq ''
          expect(row3[25]).to eq ''
          expect(row3[26]).to eq ''
          expect(row3[27]).to eq ''
          expect(row3[28]).to eq ''
          expect(row3[29]).to eq site3.id.to_s
          expect(row3[30]).to eq site3.name
          expect(row3[31]).to eq site3.url
          expect(row3[32]).to eq site3.owner_name
          expect(row3[33]).to eq site3.email
          expect(row3[34]).to eq site3.note
        end
      end
    end
  end
end
