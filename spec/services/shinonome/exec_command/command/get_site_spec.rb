# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetSite do
  describe '.execute' do
    before do
      create(:site)
      create(:site)
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['site'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetSite.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'site.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考,最終更新日,更新者\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          site2 = Site.find(row2[0])

          expect(row2[0]).to eq site2.id.to_s
          expect(row2[1]).to eq site2.name
          expect(row2[2]).to eq site2.url
          expect(row2[3]).to eq site2.owner_name
          expect(row2[4]).to eq site2.email
          expect(row2[5]).to eq site2.note
          expect(row2[6]).to eq site2.updated_at.to_s
          expect(row2[7]).to eq site2.updated_by.to_s

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          site3 = Site.find(row3[0])

          expect(row3[0]).to eq site3.id.to_s
          expect(row3[1]).to eq site3.name
          expect(row3[2]).to eq site3.url
          expect(row3[3]).to eq site3.owner_name
          expect(row3[4]).to eq site3.email
          expect(row3[5]).to eq site3.note
          expect(row3[6]).to eq site3.updated_at.to_s
          expect(row3[7]).to eq site3.updated_by.to_s
        end
      end
    end
  end
end
