# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shinonome::ExecCommand::Command::EditOriginalBook do
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

    before do
      create(:original_book, work:, booktype_id: 1, title: '底本タイトル', publisher: '底本出版社')
    end

    context '正しい引数を与えた場合' do
      it 'original_bookを含むResultを返す' do
        command = Shinonome::ExecCommand::Command.new(['底本更新', *args])
        result = Shinonome::ExecCommand::Command::EditOriginalBook.new.execute(command)
        expect(result).to be_successful
        original_books = result.command_result
        expect(original_books.count).to eq 1

        original_book = original_books.first
        expect(original_book.work_id).to eq work.id
        expect(original_book.title).to eq '底本タイトル'
        expect(original_book.publisher).to eq '底本出版社'
      end
    end

    context 'work_idが数値ではない場合' do
      it '例外をあげる' do
        args2 = args.dup
        args2[0] = 'abc'

        expect do
          Shinonome::ExecCommand::Command.new(['底本更新', *args2])
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
        command = Shinonome::ExecCommand::Command.new(['底本更新', *args2])
        expect do
          Shinonome::ExecCommand::Command::EditOriginalBook.new.execute(command)
        end.to raise_error(
          Shinonome::ExecCommand::FormatError,
          '種別フラグには"底本"か"底本の親本"を指定してください。'
        )
      end
    end

    context '種別フラグが異なる場合' do
      it '種別フラグも含めて更新される(?)' do
        args2 = args.dup
        args2[6] = '底本の親本'
        command = Shinonome::ExecCommand::Command.new(['底本更新', *args2])
        result = Shinonome::ExecCommand::Command::EditOriginalBook.new.execute(command)

        expect(result.successful?).to be true
        expect(OriginalBook.count).to eq 1

        last_original_book = OriginalBook.last
        expect(last_original_book.title).to eq '底本タイトル'
        expect(last_original_book.booktype.name).to eq '底本の親本'
        expect(last_original_book.original_book_secret.memo).to eq '備考1'
      end
    end

    context '出版社が異なる場合' do
      it '更新されない' do
        args2 = args.dup
        args2[2] = '底本出版社2'
        command = Shinonome::ExecCommand::Command.new(['底本更新', *args2])
        expect do
          Shinonome::ExecCommand::Command::EditOriginalBook.new.execute(command)
        end.not_to raise_error

        expect(OriginalBook.count).to eq 1

        last_original_book = OriginalBook.last
        expect(last_original_book.title).to eq '底本タイトル'
        expect(last_original_book.booktype.name).to eq '底本'
        expect(last_original_book.original_book_secret.memo).to eq '備考original_book'
      end
    end
  end
end
