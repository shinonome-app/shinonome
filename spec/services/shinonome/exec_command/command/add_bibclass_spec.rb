# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddBibclass do
  describe '.execute' do
    let(:work) { create(:work) }

    context '正しい引数を与えた場合' do
      it 'bibclassを含むResultを返す' do
        command = Shinonome::ExecCommand::Command.new(['分類追加', work.id.to_s, 'NDC', '913 914', '備考ABC'])

        result = Shinonome::ExecCommand::Command::AddBibclass.new.execute(command)

        expect(result).to be_successful
        bibclass = result.command_result
        expect(bibclass.work_id).to eq work.id
        expect(bibclass.name).to eq 'NDC'
        expect(bibclass.num).to eq '913 914'
        expect(bibclass.note).to eq '備考ABC'
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        expect do
          Shinonome::ExecCommand::Command.new(['分類追加', 'invalid', 'NDC', '913 914', '備考ABC'])
        end.to raise_error(Shinonome::ExecCommand::FormatError, 'BookIDが数値ではありません。')
      end
    end

    context 'work_idが存在しない場合' do
      it '例外をあげる' do
        command = Shinonome::ExecCommand::Command.new(['分類追加', '100000', 'NDC', '913 914', '備考ABC'])

        expect { Shinonome::ExecCommand::Command::AddBibclass.new.execute(command) }.to raise_error(Shinonome::ExecCommand::FormatError, '対象の作品ID100000がありません。')
      end
    end
  end
end
