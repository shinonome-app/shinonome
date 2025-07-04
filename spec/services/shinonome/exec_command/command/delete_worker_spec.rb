# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::DeleteWorker do
  let(:work) { create(:work) }
  let(:worker) { create(:worker) }
  let(:worker_role) { WorkerRole.find_by(name: '入力者') || create(:worker_role, name: '入力者') }

  before do
    create(:work_worker, work: work, worker: worker, worker_role: worker_role)
  end

  describe '#execute' do
    context '正しい引数を与えた場合' do
      it 'work_workerを削除する' do
        command = Shinonome::ExecCommand::Command.new(['耕作員削除', work.id, worker.id, '入力者'])

        expect do
          result = Shinonome::ExecCommand::Command::DeleteWorker.new.execute(command)
          expect(result).to be_successful
        end.to change(WorkWorker, :count).by(-1)

        expect(WorkWorker.where(work: work, worker: worker, worker_role: worker_role)).not_to exist
      end
    end

    context '存在しない作品IDの場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['耕作員削除', 99999, worker.id, '入力者'])

        expect do
          Shinonome::ExecCommand::Command::DeleteWorker.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /対象の作品ID99999がありません/)
      end
    end

    context '存在しない耕作員IDの場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['耕作員削除', work.id, 99999, '入力者'])

        expect do
          Shinonome::ExecCommand::Command::DeleteWorker.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /対象の耕作員ID99999が見つかりません/)
      end
    end

    context '存在しない役割名の場合' do
      it 'FormatErrorが発生する' do
        command = Shinonome::ExecCommand::Command.new(['耕作員削除', work.id, worker.id, '存在しない役割'])

        expect do
          Shinonome::ExecCommand::Command::DeleteWorker.new.execute(command)
        end.to raise_error(Shinonome::ExecCommand::FormatError, /役割フラグには/)
      end
    end

    context '該当するwork_workerが存在しない場合' do
      it 'レコードが見つからないエラーが発生する' do
        other_worker = create(:worker)
        command = Shinonome::ExecCommand::Command.new(['耕作員削除', work.id, other_worker.id, '入力者'])

        expect do
          Shinonome::ExecCommand::Command::DeleteWorker.new.execute(command)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
