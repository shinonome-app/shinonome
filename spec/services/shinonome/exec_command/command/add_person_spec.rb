# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddPerson do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:person) { create(:person) }

    context '正しい引数を与えた場合' do
      it 'work_personを含むResultを返す' do
        command = Shinonome::ExecCommand::Command.new(['人物追加', work.id, person.id, '著者'])

        result = Shinonome::ExecCommand::Command::AddPerson.new.execute(command)
        expect(result).to be_successful
        expect(result.command_result.role_id).to eq 1
      end
    end

    context '存在しないroleを与えた場合' do
      it '例外をあげる' do
        command = Shinonome::ExecCommand::Command.new(['人物追加', work.id, person.id, '役割テスト'])

        expect do
          Shinonome::ExecCommand::Command::AddPerson.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '役割フラグには"著者"か"翻訳者"か"校訂者"か"編者"か"監修者"か"その他"を指定してください。'
        )
      end
    end
  end
end
