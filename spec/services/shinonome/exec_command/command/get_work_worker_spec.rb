# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetWorkWorker do
  describe '.execute' do
    before do
      create(:work_worker)
      create(:work_worker, worker_role_id: 2)
    end

    it '正しいCSVが生成される' do
      command = Shinonome::ExecCommand::Command.new(['book_worker'])

      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetWorkWorker.new.execute(command, output_dir: dir)
        output_file = File.join(dir, 'book_worker.csv')
        File.open(output_file) do |f|
          line1 = f.gets
          expect(line1).to eq "#{Shinonome::ExecCommand::BOM}bookid,工作員id,役割フラグ\r\n"

          ## line 2
          line2 = f.gets
          row2 = CSV.parse(line2)[0]
          work_worker2 = WorkWorker.where(work_id: row2[0], worker_id: row2[1]).first

          expect(row2[2]).to eq work_worker2.worker_role.name

          ## line 3
          line3 = f.gets
          row3 = CSV.parse(line3)[0]
          work_worker3 = WorkWorker.where(work_id: row3[0], worker_id: row3[1]).first

          expect(row3[2]).to eq work_worker3.worker_role.name
        end
      end
    end
  end
end
