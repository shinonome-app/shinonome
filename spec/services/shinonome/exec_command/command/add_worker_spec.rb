# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddWorker do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:worker) { create(:worker) }

    context '正しい引数を与えた場合' do
      it 'work_workerを含むResultを返す' do
        command = Shinonome::ExecCommand::Command.new(['工作員追加', work.id, worker.id, '校正者'])

        result = Shinonome::ExecCommand::Command::AddWorker.new.execute(command)
        expect(result).to be_successful
        expect(result.command_result.worker_role_id).to eq 2
      end
    end

    context 'worker_idが数値ではない場合' do
      it '例外をあげる' do
        command = Shinonome::ExecCommand::Command.new(['工作員追加', work.id, 'abc', '校正者'])

        expect do
          Shinonome::ExecCommand::Command::AddWorker.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '工作員IDが数値ではありません。'
        )
      end
    end

    context 'work_idが存在しない場合' do
      it '例外をあげる' do
        command = Shinonome::ExecCommand::Command.new(['工作員追加', 100000, 'abc', '校正者'])

        expect { Shinonome::ExecCommand::Command::AddWorker.new.execute(command) }.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end

    context '存在しないworker_roleを与えた場合' do
      it '例外をあげる' do
        command = Shinonome::ExecCommand::Command.new(['工作員追加', work.id, worker.id, '役割テスト'])

        expect do
          Shinonome::ExecCommand::Command::AddWorker.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '役割フラグには"入力者"か"校正者"か"その他"を指定してください。'
        )
      end
    end
  end
end
