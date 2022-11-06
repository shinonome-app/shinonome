# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::GetFile do
  describe '.execute' do
    let(:input_worker) { create(:worker) }
    let(:proofread_worker) { create(:worker) }
    let(:work) { create(:work, original_title: nil) }
    let(:workfile) { create(:workfile, work: work, filetype_id: 9, compresstype_id: 1) }

    before do
      create(:work_worker, work: work, worker: input_worker, worker_role_id: 1)
      create(:work_worker, work: work, worker: proofread_worker, worker_role_id: 2)

      SampleFileGenerator.new.generate_sample_html(workfile)
      workfile.reload
    end

    it '正しいファイルが生成される' do
      Dir.mktmpdir do |dir|
        Shinonome::ExecCommand::Command::GetFile.new.execute(work.id, workfile.filetype_id, workfile.compresstype_id, nil, output_dir: dir)

        output_file = File.join(dir, workfile.filename)
        File.open(output_file) do |f|
          content = f.read
          expect(content).to start_with "<html>\n<head>\n<title>#{work.title}</title>\n"
          expect(content).to include "#{work.title}\n#{work.subtitle}"
          expect(content).to include "入力：#{input_worker.name}"
          expect(content).to include "校正：#{proofread_worker.name}"
        end
      end
    end
  end
end
