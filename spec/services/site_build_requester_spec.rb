# frozen_string_literal: true

require 'rails_helper'
require 'tmpdir'

RSpec.describe SiteBuildRequester do
  let(:control_dir) { Dir.mktmpdir }

  before { stub_const('SiteBuildRequester::CONTROL_DIR', control_dir) }
  after { FileUtils.remove_entry(control_dir) }

  describe '#request!' do
    it 'build.request を作成し pending? が true になる' do
      expect(SiteBuildRequester.new.request!).to be(true)
      expect(SiteBuildRequester.new.pending?).to be(true)
    end
  end

  describe '#status' do
    it '未実行なら nil' do
      expect(SiteBuildRequester.new.status).to be_nil
    end

    it 'done 行をパースして state/pages を返す' do
      File.write(File.join(SiteBuildRequester::CONTROL_DIR, 'build.status'),
                 "done\t2026-06-20 12:00:00 +0900\tpages=24500\n")
      status = SiteBuildRequester.new.status
      expect(status.state).to eq('done')
      expect(status.pages).to eq('24500')
    end

    it 'running 行は pages が nil' do
      File.write(File.join(SiteBuildRequester::CONTROL_DIR, 'build.status'),
                 "running\t2026-06-20 12:00:00 +0900\n")
      status = SiteBuildRequester.new.status
      expect(status.state).to eq('running')
      expect(status.pages).to be_nil
    end
  end
end
