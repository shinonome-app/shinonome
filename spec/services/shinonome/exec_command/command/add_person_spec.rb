# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddPerson do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:person) { create(:person) }

    context '正しい引数を与えた場合' do
      it 'work_personを含むResultを返す' do
        result = Shinonome::ExecCommand::Command::AddPerson.new.execute(work.id, person.id, '著者')
        expect(result).to be_successful
        expect(result.command_result.role_id).to eq 1
      end
    end

    context '存在しないroleを与えた場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command::AddPerson.new.execute(work.id, person.id, '役割テスト')
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '役割フラグには"著者"か"翻訳者"か"校訂者"か"編者"か"その他"を指定してください。'
        )
      end
    end
  end
end
