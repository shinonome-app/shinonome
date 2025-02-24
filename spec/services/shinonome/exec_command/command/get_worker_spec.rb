# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetWorker do
  describe '.execute' do
    before do
      create(:worker_secret)
      create(:worker_secret)
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['worker'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetWorker.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'worker.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}耕作員id,姓名,姓名読み,email,url,備考,最終更新日,更新者,姓名ソート用読み\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          worker2 = Worker.find(row2[0])
          expect(row2[1]).to eq worker2.name
          expect(row2[2]).to eq worker2.name_kana
          expect(row2[3]).to eq worker2.worker_secret.email
          expect(row2[4]).to eq worker2.worker_secret.url
          expect(row2[5]).to eq worker2.worker_secret.note
          expect(row2[6]).to eq worker2.updated_at.to_s
          expect(row2[7]).to eq worker2.updated_by.to_s
          expect(row2[8]).to eq worker2.sortkey

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          worker3 = Worker.find(row3[0])
          expect(row3[1]).to eq worker3.name
          expect(row3[2]).to eq worker3.name_kana
          expect(row3[3]).to eq worker3.worker_secret.email
          expect(row3[4]).to eq worker3.worker_secret.url
          expect(row3[5]).to eq worker3.worker_secret.note
          expect(row3[6]).to eq worker3.updated_at.to_s
          expect(row3[7]).to eq worker3.updated_by.to_s
          expect(row3[8]).to eq worker3.sortkey
        end
      end
    end
  end
end
