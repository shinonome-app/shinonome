# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetPerson do
  describe '.execute' do
    before do
      create(:person)
      create(:person)
    end

    it '正しいCSVが生成される' do
      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetPerson.new.execute(output_dir: dir)
        output_file = File.join(dir, 'person.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}人物id,姓,姓読み,姓英字,名,名読み,名英字,生年月日,没年月日,著作権フラグ,email,url,人物について,人物基本名,備考,最終更新日,更新者,姓ソート用読み,名ソート用読み\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          person2 = Person.find(row2[0])
          expect(row2[1]).to eq person2.last_name
          expect(row2[2]).to eq person2.last_name_kana
          expect(row2[3]).to eq person2.last_name_en
          expect(row2[4]).to eq person2.first_name
          expect(row2[5]).to eq person2.first_name_kana
          expect(row2[6]).to eq person2.first_name_en
          expect(row2[7]).to eq person2.born_on
          expect(row2[8]).to eq person2.died_on
          expect(row2[9]).to eq person2.copyright_char
          expect(row2[10]).to eq person2.email
          expect(row2[11]).to eq person2.url
          expect(row2[12]).to eq person2.description
          expect(row2[13]).to eq person2.basename.to_s
          expect(row2[14]).to eq person2.note
          expect(row2[16]).to eq person2.updated_by.to_s
          expect(row2[17]).to eq person2.sortkey
          expect(row2[18]).to eq person2.sortkey2

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          person3 = Person.find(row3[0])
          expect(row3[1]).to eq person3.last_name
          expect(row3[2]).to eq person3.last_name_kana
          expect(row3[3]).to eq person3.last_name_en
          expect(row3[4]).to eq person3.first_name
          expect(row3[5]).to eq person3.first_name_kana
          expect(row3[6]).to eq person3.first_name_en
          expect(row3[7]).to eq person3.born_on
          expect(row3[8]).to eq person3.died_on
          expect(row3[9]).to eq person3.copyright_char
          expect(row3[10]).to eq person3.email
          expect(row3[11]).to eq person3.url
          expect(row3[12]).to eq person3.description
          expect(row3[13]).to eq person3.basename.to_s
          expect(row3[14]).to eq person3.note
          expect(row3[16]).to eq person3.updated_by.to_s
          expect(row3[17]).to eq person3.sortkey
          expect(row3[18]).to eq person3.sortkey2
        end
      end
    end
  end
end
