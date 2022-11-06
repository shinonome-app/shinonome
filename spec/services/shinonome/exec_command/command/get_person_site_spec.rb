# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetPersonSite do
  describe '.execute' do
    before do
      create(:person_site)
      create(:person_site)
    end

    it '正しいCSVが生成される' do
      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetPersonSite.new.execute(output_dir: dir)
        output_file = File.join(dir, 'person_site.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}人物id,姓,姓読み,姓英字,名,名読み,名英字,生年月日,没年月日,著作権フラグ,関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          person2 = Person.find(row2[0])
          site2 = person2.sites[0]

          expect(row2[1]).to eq person2.last_name
          expect(row2[2]).to eq person2.last_name_kana
          expect(row2[3]).to eq person2.last_name_en
          expect(row2[4]).to eq person2.first_name
          expect(row2[5]).to eq person2.first_name_kana
          expect(row2[6]).to eq person2.first_name_en
          expect(row2[7]).to eq person2.born_on
          expect(row2[8]).to eq person2.died_on
          expect(row2[9]).to eq person2.copyright_char
          expect(row2[10]).to eq site2.id.to_s
          expect(row2[11]).to eq site2.name
          expect(row2[12]).to eq site2.url
          expect(row2[13]).to eq site2.owner_name
          expect(row2[14]).to eq site2.email
          expect(row2[15]).to eq site2.note
        end
      end
    end
  end
end
