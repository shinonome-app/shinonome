# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::AddOriginalBook do
  describe '.execute' do
    let(:work) { create(:work) }
    let(:args) do
      [
        work.id,
        '底本タイトル',
        '底本出版社',
        '初出年',
        '入力版',
        '校正版',
        '底本',
        '備考1'
      ]
    end

    context '正しい引数を与えた場合' do
      it 'original_bookを含むResultを返す' do
        command = Shinonome::ExecCommand::Command.new(['底本追加', *args])
        result = Shinonome::ExecCommand::Command::AddOriginalBook.new.execute(command)
        expect(result).to be_successful
        original_book = result.command_result
        expect(original_book.work_id).to eq work.id
        expect(original_book.title).to eq '底本タイトル'
        expect(original_book.publisher).to eq '底本出版社'
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        args2 = args.dup
        args2[0] = 'abc'
        command = Shinonome::ExecCommand::Command.new(['底本追加', *args2])

        expect do
          Shinonome::ExecCommand::Command::AddOriginalBook.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          'BookIDが数値ではありません。'
        )
      end
    end

    context '種別フラグが正しくない場合' do
      it '例外をあげる' do
        args2 = args.dup
        args2[6] = '底本2'
        command = Shinonome::ExecCommand::Command.new(['底本追加', *args2])

        expect do
          Shinonome::ExecCommand::Command::AddOriginalBook.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '種別フラグには"底本"か"底本の親本"を指定してください。'
        )
      end
    end
  end
end
